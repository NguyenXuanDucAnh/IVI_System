if (!window.shopacado) window.shopacado = {};

window.shopacado.log = (msg, data={}) => {
    if (window.shopacado.debug) {
        console.log("SHOPACADO DEBUG1: " + msg, data);
    }
}

/**
 * Update items that are affected by a variant change such as the
 * discount table and lowest price message on the product page from an
 * html source. When a variant changes, some themes update by making
 * an ajax call to the product page with the newly selected variant as a
 * parameter and then parsing the necessary values out of that html.
 * @param {*} html the html of the page loaded via ajax call
 */
window.shopacado.productUpdateViaHtmlSource = (html) => {
    // discount table
    const sourceDiscountTables = html.getElementsByClassName("shopacado-discount-table");
    if (sourceDiscountTables.length > 0) {
      const destinationDiscountTables = document.getElementsByClassName("shopacado-discount-table");
      for (let i = 0; i < destinationDiscountTables.length; i++) {
        destinationDiscountTables[i].innerHTML = sourceDiscountTables[0].innerHTML;
      }
    }

    // lowest price
    const sourceLowestPriceDiv = html.getElementById("shopacado-lowest-price");
    if (sourceLowestPriceDiv) {
        window.shopacado.showLowestPriceFromElement(sourceLowestPriceDiv);
    }
}


/**
 * Update items that are affected by a variant change such as the
 * discount table and lowest price message on the product page.
 * @param {*} price the price of the newly selected variant
 */
window.shopacado.productUpdateWithNewPrice = (price) => {
    console.log("Updating product with new price: " + price);
    // discount table
    const discountCells = document.getElementsByClassName("shopacado-custom-table-val");
    for (let i = 0; i < discountCells.length; i++) {
        const discountCell = discountCells[i];
        const template = discountCell.getAttribute("data-shopacado-template");

        const valsRequiringUpdate = [
            "#dollar_discount#",
            "#dollar_amount#",
            "#percent_discount#",
            "#percent_discount_rounded#"
        ];

        if (!valsRequiringUpdate.find(val => template.includes(val))) {
            continue;
        }

        const row_type = discountCell.getAttribute("data-shopacado-row-type");
        const discount_type = discountCell.getAttribute("data-shopacado-discount-type");
        const discount = discountCell.getAttribute("data-shopacado-discount-val");
        const offer_type = discountCell.getAttribute("data-shopacado-offer-type");
        const money_format = discountCell.getAttribute("data-money-format");

        const new_value = window.shopacado.getDiscountCellValue(template, price, row_type, discount_type, discount, offer_type, money_format);
        discountCell.innerHTML = new_value;
    }

    // lowest price
    const lowestPriceDiv = document.getElementById("shopacado-lowest-price");
    if (lowestPriceDiv) {
        const template = lowestPriceDiv.getAttribute("data-shopacado-template");
        const selector = lowestPriceDiv.getAttribute("data-shopacado-selector");
        const row_type = lowestPriceDiv.getAttribute("data-shopacado-row-type");
        const discount = lowestPriceDiv.getAttribute("data-shopacado-discount-val");
        const money_format = lowestPriceDiv.getAttribute("data-money-format");

        let lowestPrice = price;
        if (row_type === "fixed") {
            lowestPrice = discount;
        } else if (row_type === "off") {
            lowestPrice = price - discount;
        } else if (row_type === "percent") {
            lowestPrice = price - (price * (discount / 100.0));
        }

        const lowestPriceFormatted = window.shopacado.formatMoney(lowestPrice, money_format);
        const formattedMessage = template.replaceAll("{{price}}", lowestPriceFormatted).replaceAll("{{ price }}", lowestPriceFormatted);
        const priceElements = window.shopacado.getPriceElementsFromSelector(selector);
        if (priceElements) {
            priceElements.forEach((priceElement) => {
                priceElement.innerHTML = formattedMessage;
            });
        }
    }
}

window.shopacado.getPriceElementsFromSelector = (selector) => {

    if (selector) {
        const priceElements = document.querySelectorAll(selector);
        if (priceElements && priceElements.length > 0) return priceElements;
    } 
    
    if (window.shopacado.defaultProductPagePriceSelector) {
        return document.querySelectorAll(window.shopacado.defaultProductPagePriceSelector); 
    }

    return false;

}

window.shopacado.getDiscountCellValue = (template, price, row_type, discount_type, discount, offer_type, money_format) => {
    let percentDiscount = 0;
    let dollarDiscount = 0;
    let dollarAmount = 0;

    if (row_type === "percent") {
        percentDiscount = discount * 1.0;
        dollarDiscount = price * (discount / 100.0);
        dollarAmount = price - dollarDiscount;
        
        if (discount_type === "percent_off" && offer_type === "SPEND_AMOUNT_GET_DISCOUNT") {
            dollarDiscount = 0;
            percentDiscount = 0;
        }
    } else if (row_type === "off") {
        dollarDiscount = discount;
        dollarAmount = price - dollarDiscount;
        percentDiscount = dollarDiscount / price;
    } else if (row_type === "fixed") {
        dollarAmount = discount;

        if (discount_type === "dollar_off" && (offer_type === "BUY_X_FOR_DOLLAR" || offer_type === "SPEND_AMOUNT_GET_DISCOUNT")) {
            dollarDiscount = 0;
            percentDiscount = 0;
        } else {
            dollarDiscount = price - dollarAmount;
            percentDiscount = dollarDiscount / price;
        }
    }

    percentDiscount = percentDiscount
    let percentDiscountRounded = Math.floor(percentDiscount);
    dollarAmount = window.shopacado.formatMoney(dollarAmount, money_format);
    dollarDiscount = window.shopacado.formatMoney(dollarDiscount, money_format);

    return template
        .replaceAll("#dollar_amount#", dollarAmount)
        .replaceAll("#dollar_discount#", dollarDiscount)
        .replaceAll("#percent_discount#", percentDiscount + "%")
        .replaceAll("#percent_discount_rounded#", percentDiscountRounded + "%");
}

/**
 * A function to format a currency value in the stores money format.
 * @param {*} cents 
 * @param {*} formatString 
 * @returns the formatted price string
 */
window.shopacado.formatMoney = (cents, formatString) => {
    if (typeof cents == 'string') { cents = cents.replace('.',''); }
    let value = '';
    let placeholderRegex = /\{\{\s*(\w+)\s*\}\}/;
  
    function defaultOption(opt, def) {
       return (typeof opt == 'undefined' ? def : opt);
    }
  
    function formatWithDelimiters(number, precision, thousands, decimal) {
        precision = defaultOption(precision, 2);
        thousands = defaultOption(thousands, ',');
        decimal   = defaultOption(decimal, '.');

        if (isNaN(number) || number == null) { return 0; }

        number = (number/100.0).toFixed(precision);

        var parts   = number.split('.'),
            dollars = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1' + thousands),
            cents   = parts[1] ? (decimal + parts[1]) : '';

        return dollars + cents;
    }
  
    switch(formatString.match(placeholderRegex)[1]) {
        case 'amount':
            value = formatWithDelimiters(cents, 2);
            break;
        case 'amount_no_decimals':
            value = formatWithDelimiters(cents, 0);
            break;
        case 'amount_with_comma_separator':
            value = formatWithDelimiters(cents, 2, '.', ',');
            break;
        case 'amount_no_decimals_with_comma_separator':
            value = formatWithDelimiters(cents, 0, '.', ',');
            break;
    }
  
    return formatString.replace(placeholderRegex, value);
}

window.shopacado.showLowestPriceFromElement = (el) => {
    const lowestPriceData = window.shopacado.getLowestPriceFromElement(el);
    if (lowestPriceData) {
        const { price, selector, template } = lowestPriceData;

        const priceElements = window.shopacado.getPriceElementsFromSelector(selector);
        if (priceElements) {
            for (let i = 0; i < priceElements.length; i++) {
                // console.log("Updating price elements with lowest price: " + price, priceElements[i]);
                priceElements[i].innerHTML = template.replace("{{price}}", price);
            }
        }
    }
}

window.shopacado.getLowestPriceFromElement = (el) => {
    if (el) {
        return {
            price: el.innerHTML,
            selector: el.getAttribute("data-shopacado-selector"),
            template: el.getAttribute("data-shopacado-template")
        }
    }
    return false;
}

window.addEventListener('load', function() {
    document.dispatchEvent(new CustomEvent('shopacado-loaded'));
});


// Code Examples

// Triggering Price Update Via HTML
// try {
//     window.shopacado.productUpdateViaHtmlSource(html);
// } catch (error) {
//     console.error("failed to call shopacado productUpdateViaHtmlSource: " + error.message);
// }

// Triggering Price Update Via new price
// try {
//     window.shopacado.productUpdateWithNewPrice(price);
// } catch (error) {
//     console.error("failed to call shopacado productUpdateWithNewPrice: " + error.message);
// }
