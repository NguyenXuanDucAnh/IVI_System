! function (window, document) {
    window.shopacado.responseStore = {};

    if (!window.shopacado.log) {
        window.shopacado.log = (msg, data={}) => {
            if (window.shopacado.debug) {
                console.log("SHOPACADO DEBUG3: " + msg, data);
            }
        }
    }

    function cartChanged(newCart) {
        const oldCart = window.shopacado.responseStore.cartJS;
        if (!oldCart) {
            return true;
        }

        const cartPropertiesToCompare = [
            "original_total_price",
            "total_discount",
            "total_weight",
            "item_count",
            "items_subtotal_price"
        ];

        for (let i = 0; i < cartPropertiesToCompare.length; i++) {
            const prop = cartPropertiesToCompare[i];
            if (oldCart[prop] !== newCart[prop]) {
                return true;
            }
        }

        if(oldCart.items.length !== newCart.items.length) {
            return true;
        }

        for (let j = 0; j < oldCart.items.length; j++) {
            const oldItem = oldCart.items[j];
            const newItem = newCart.items[j];
            if (oldItem.id !== newItem.id || oldItem.quantity !== newItem.quantity) {
                return true;
            }
        }

        return false;
    }

    function shopacadoCartGet(id=1) {
        return window.fetch(`/cart.js?shopacado=${id}`, {
            method: 'GET'
        });
    }

    function processCartData(cartData) {
        if (cartChanged(cartData)) {
            window.shopacado.log("cart changed", cartData);
            window.shopacado.responseStore.cartJS = cartData;
            return requestDiscounts();
        } else {
            window.shopacado.log("cart not changed", cartData);
        }

        return true;
    }

    function setCookieSession(t, e) {
        document.cookie = t + "=" + e + "; path=/;"
    }
    
    function getCookie(t) {
        for (var e = t + "=", n = document.cookie.split(";"), o = 0; o < n.length; o++) {
            for (var i = n[o];
                    " " == i.charAt(0);) i = i.substring(1);
            if (0 == i.indexOf(e)) return i.substring(e.length, i.length)
        }
        return ""
    }
    
    function deleteCookie(t) {
        var o = new Date;
        o.setTime(o.getTime() - 1000);
        var i = "expires=" + o.toUTCString();
        document.cookie = t + "=; " + i + "; path=/;"
    }
    
    function checkForTestOffer() {
        window.shopacado.test_offer_token = getCookie('shopacado-test-offer-token');
        window.shopacado.test_offer_name = getCookie('shopacado-test-offer-name');

        if (window.shopacado.test_offer_token && window.shopacado.test_offer_token != "") {
            showTestOfferNotice();
        }
    }

    function showTestOfferNotice() {
        let message = `Testing Offer: ${window.shopacado.test_offer_name}`;
        const m = document.getElementById("shopacado-banner-message");
        m && (m.innerHTML = message);

        const b = document.getElementById("shopacado-banner");
        b && b.classList.remove('shopacado-hidden');

        document.body.classList.add("push-down");
    }

    function removeTestOffer() {
        const b = document.getElementById("shopacado-banner");
        b && b.classList.add('shopacado-hidden');

        const m = document.getElementById("shopacado-banner-message");
        m && (m.innerHTML = "");

        document.body.classList.remove("push-down");

        deleteCookie("shopacado-test-offer-token");
        deleteCookie("shopacado-test-offer-name");
        delete window.shopacado.test_offer_token;
        delete window.shopacado.test_offer_name;
    }
    window.shopacado.removeTestOffer = removeTestOffer;

    function getUrlParam(paramName) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(paramName);
    }

    async function handleXMLHttpRequestResponse(xhr) {
        const url = xhr._url;
        const method = xhr._method;

        if (xhr.responseType !== "" && xhr.responseType !== "text") return false;

        const responseText = xhr.responseText;

        let responseJson = null;
        try {
            responseJson = JSON.parse(responseText);

            if (!responseJson) {
                return false;
            }
        } catch (e) {
            return false;
        }

        // window.shopacado.log("XMLHttpRequest", responseJson, url, method);

        if (url.includes("/cart/change") ||
            url.includes("/cart/add") ||
            url.includes("/cart/update") ||
            url.includes("/cart/clear")) {

            if (url.includes("/cart/change")) {
                return processCartData(responseJson);
            } else if (url.includes("/cart/add")) {
                return processCartData(responseJson);
            } else if (url.includes("/cart/update")) {
                return processCartData(responseJson);
            } else if (url.includes("/cart/clear")) {
                // TODO? shouldn't be needed
            }

        }

        return false;
    }

    async function handleAjaxResponse(url, data, response) {
        if (url.includes("cart/update.js?shopacado=1")) return false;

        if (url.includes("/cart.js?shopacado=2")) return false;

        if (url.includes("/cart.js?shopacado=1") && data?.method === "GET") {
            const clonedOriginal = response.clone();
            const json = await clonedOriginal.json();
            return processCartData(json);
        }
        
        if (!window.shopacado.interceptAjax) {
            return false;
        }

        if (url.includes("/cart/change") ||
            url.includes("/cart/add") ||
            url.includes("/cart/update") ||
            url.includes("/cart/clear")) {

            if(data?.body instanceof FormData) {
                // window.shopacado.log(data.body);
                // window.shopacado.log(data.body.get("sections"));
                // window.shopacado.log(data.body.get("section-id"));
                // window.shopacado.log(data.body.get("sections_url"));

                window.shopacado.cartSections = data.body.get("sections");
            } else {
                try {
                    const body = arguments[1].body ? JSON.parse(arguments[1].body) : null;
                    window.shopacado.cartSections = body?.sections ? body.sections : null;
                } catch (e) {
                    console.log(e);
                }
            }

            if (url.includes("/cart/change")) {
                const clonedOriginal = response.clone();
                const json = await clonedOriginal.json();
                return processCartData(json);
            } else if (url.includes("/cart/add")) {
                const cartDataResponse = await shopacadoCartGet(2);
                const cartData = await cartDataResponse.json();
                return processCartData(cartData);
            } else if (url.includes("/cart/update")) {
                const clonedOriginal = response.clone();
                const json = await clonedOriginal.json();
                return processCartData(json);
            } else if (url.includes("/cart/clear")) {
                // TODO? shouldn't be needed
            }

        } else if (url.includes("/cart")) {
            // TODO: make this permanent
            try {
                window.shopacado.cartUpdateHandler(1000);
            } catch (e) {
                console.log(e);
            }
        } else if (url.includes("/graphql.json?operation_name=cartQuery")) {
            // TODO: make this permanent
            try {
                window.shopacado.cartUpdateHandler(1000);
            } catch (e) {
                console.log(e);
            }
        }

        return false;
    }

    function updateCartAttributesViaAjax(attributes) {
        let data = {
            attributes
        };
        if (window.shopacado.cartSections && window.shopacado.cartSections.length > 0) {
            data.sections = window.shopacado.cartSections
        }

        window.shopacado.log("updateCartAttributesViaAjax:data", data);

        return fetch('/cart/update.js?shopacado=1', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });
    }

    function updateCartAttributesViaUrl(attributes) {
        let queryString = "";
        for (let key in attributes) {
            queryString += `attributes[${key}]=${attributes[key]}&`;
        }
        const url = `${Shopify.routes.root}cart/update?${queryString}shopacado=1`;
        window.shopacado.log('cart update url', url);
        window.location.href = url;
    }

    function insertCartSnippets() {
        window.shopacado.log("inserting cart snippets");
        if (window.shopacado?.themeSettings?.product_title_selector) {
            insertCartTitleSnippet(window.shopacado.themeSettings.product_title_selector);
        }
        if (window.shopacado?.themeSettings?.regular_product_title_selector) {
            insertCartTitleSnippet(window.shopacado.themeSettings.regular_product_title_selector);
        }
    }
    
    function insertCartTitleSnippet(productTitleSelector) {
        window.shopacado.log("inserting cart title snippet", productTitleSelector);
        if (!productTitleSelector) {
            return false;
        }

        const cartItems = window.shopacado.payload.cart.items;
        const selectors = productTitleSelector.split(",");
        for (let i = 0; i < selectors.length; i++) {
            const elems = document.querySelectorAll(selectors[i]);

            for (let j = 0; j < elems.length; j++) {
                const elem = elems[j];

                let cartItem;
                if (j >= cartItems.length) {
                    cartItem = cartItems[j - cartItems.length]
                } else {
                    cartItem = cartItems[j];
                }

                if (cartItem && elem && elem.innerHTML.indexOf("shopacado-cart-item-success-notes") === -1) {
                    elem.innerHTML += `<span class='shopacado-cart-item-success-notes' data-key='${cartItem.key}'></span>` +
                                      `<span class='shopacado-cart-item-upsell-notes' data-key='${cartItem.key}'></span>`;
                }
            }
        }
    }
    
    function updateCartItems() {
        const items = window.shopacado?.responseStore?.discountAPI?.discounts?.cart?.items;
        window.shopacado.log("updating cart items", items);

        if (window.shopacado.product && window.shopacado?.responseStore?.discountAPI?.product && window.shopacadoLegacy.showDiscountTable) {
            window.shopacadoLegacy.showDiscountTable(window.shopacado.responseStore.discountAPI.product);
        }

        if (items) {
            for (let e = 0; e < items.length; e++) {
                const n = items[e];

                n.upsell_note = n.upsell_note ? n.upsell_note : "";
                n.success_note = n.success_note ? n.success_note : "";

                const upsellElements = document.querySelectorAll(".shopacado-cart-item-upsell-notes[data-key='" + n.key + "']");

                for (let u = 0; u < upsellElements.length; u++) {
                    upsellElements[u].innerHTML = n.upsell_note;
                }

                const successElements = document.querySelectorAll(".shopacado-cart-item-success-notes[data-key='" + n.key + "']");
                for (let s = 0; s < successElements.length; s++) {
                    successElements[s].innerHTML = n.success_note;
                }
            }
        }

        document.dispatchEvent(
            new CustomEvent("shopacado:cart:render:messaging")
        );
    };

    async function requestDiscounts(noUpdate=false) {
        window.shopacado.log("requesting discounts");
        window.shopacado.payload.test_offer_token = window.shopacado.test_offer_token || null;
        

        let cartData = window.shopacado.responseStore.cartJS;

        if (window.shopacadoLegacy?.vd_placement_settings && !window.shopacadoLegacy.vd_placement_settings.use_app_blocks && window.shopacado.product) {
            window.shopacado.payload.product = window.shopacado.product;
        } else if (!cartData?.items) {
            return false;
        }

        if (cartData?.items?.length > 0) {
            window.shopacado.payload.cart = {
                items: cartData.items.map(item => {
                    return {
                        product_id: item.product_id,
                        collection_ids: item.collection_ids,
                        quantity: item.quantity,
                        key: item.key,
                        line_price: item.line_price,
                        original_line_price: item.original_line_price,
                        price: item.price,
                        original_price: item.original_price,
                        variant_id: item.variant_id,
                        properties: item.properties,
                        compare_at_price: item.compare_at_price || null,
                        compare_at_line_price: item.compare_at_line_price || null,
                    };
                }),
                currency: cartData.currency,
                total_price: cartData.total_price,
                original_total_price: cartData.original_total_price,
                compare_at_total_price: cartData.compare_at_total_price || null,
                token: cartData.token
            };

            for (let i = 0; i < cartData.items.length; i++) {
                if (window.shopacado.payload.cart_product_ids.indexOf(cartData.items[i].product_id) === -1) {
                    window.shopacado.payload.cart_product_ids.push(cartData.items[i].product_id);
                }
            }

            for (let i in window.shopacado.payload.cart.items) {
                const productId = window.shopacado.payload.cart.items[i].product_id;
                if (window.shopacado.productCollections && window.shopacado.productCollections[productId]) {
                    window.shopacado.payload.cart.items[i].collection_ids = window.shopacado.productCollections[productId];
                } else {
                    window.shopacado.payload.cart.items[i].collection_ids = null;
                }
            }
        }

        return window.fetch(window.shopacado.app_root_url, {
            method: 'POST',
            cache: 'no-store',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(window.shopacado.payload)
        })
        .then(async function(data) {
            const json = await data.json();

            window.shopacado.responseStore.discountAPI = json;

            if (window.shopacado.is_cart_page) {
                if (json.notifications?.length > 0 && json.notifications[0] !== "") {
                    const m = document.getElementsByClassName("shopacado-cart-notification-message");
                    for (let i = 0; i < m.length; i++) {
                        m[i].innerHTML = json.notifications[0];
                    }

                    const b = document.getElementsByClassName("shopacado-cart-notification");
                    for (let j = 0; j < b.length; j++) {
                        b[j].classList.remove('shopacado-hidden');
                    }
                }
            }

            insertCartSnippets();
            updateCartItems();

            if (noUpdate) {
                return true;
            }

            let newAttributes = {};
            if (json?.vp) {
                newAttributes = {
                    __shopacado_vp_data: json.vp.data,
                    __shopacado_vp_sig: json.vp.signature
                };
            } else {
                newAttributes = {
                    __shopacado_vp_data: null,
                    __shopacado_vp_sig: null
                };
            }
            if (json?.vo?.data && json?.vo?.signature) {
                newAttributes.__shopacado_vo_data = json.vo.data;
                newAttributes.__shopacado_vo_sig = json.vo.signature;
            } else {
                newAttributes.__shopacado_vo_data = null;
                newAttributes.__shopacado_vo_sig = null;
            }

            if (Object.keys(newAttributes).length > 0) {
                const updateResponse = await updateCartAttributesViaAjax(newAttributes);
                const clonedResponse = updateResponse.clone();
                const jsonResponse = await clonedResponse.json();

                document.dispatchEvent(
                    new CustomEvent("shopacado:cart:update", {
                        detail: {
                            cart: jsonResponse,
                        },
                    })
                );

                if (window.shopacado.interceptCartChangeUrl && window.shopacado.is_cart_page) {
                    window.location.href = `${Shopify.routes.root}cart/update`;
                } else if (window.shopacado.interceptAjax) {
                    return updateResponse;
                } else if (window.shopacado.interceptXMLHttpRequest) {
                    if (window.shopacado.is_cart_page) {
                        window.location.href = `${Shopify.routes.root}cart/update`;
                    } else {
                        return updateResponse;
                    }
                }
            }

            return false;
        })
        .catch((err) => {
            console.log(err);
            throw err;
        });
    }

    if (window.shopacado.is_cart_page) {
        window.shopacado.cartSections = [];
        const sectionElements = document.getElementsByClassName('shopify-section');
        for (let i = 0; i < sectionElements.length; i++) {
            const sectionElement = sectionElements[i];
            const sectionId = sectionElement.id;
            if (sectionId.endsWith('__cart-items') || sectionId.endsWith('__cart-footer')) {
                window.shopacado.cartSections.push(sectionId.replace('shopify-section-', ''));
            }
        }
    }

    window.shopacado.waitForDomLoad(async () => {
        window.shopacado.log("DOMContentLoaded - shopacado additional js loaded");

        window.shopacadoLegacy.discount_table_code && eval(window.shopacadoLegacy.discount_table_code);

        let requestedDiscounts = false;

        const b = document.getElementById("shopacado-banner");
        if (!b) {
            const banner = document.createElement("div");
            banner.id = "shopacado-banner";
            banner.classList.add("shopacado-hidden");
            banner.innerHTML = `
                <div id="shopacado-banner-content">
                    <span id="shopacado-banner-message"></span>
                    <button id="shopacado-stop-test-offer" onClick="window.shopacado.removeTestOffer()">Stop Testing</button>
                </div>
            `;
            document.body.appendChild(banner);
        }

        const testOfferParam = getUrlParam('shopacadoTestToken');
        const testOfferName = getUrlParam('shopacadoTestName');
        if (testOfferParam) {
            setCookieSession('shopacado-test-offer-token', testOfferParam);
            setCookieSession('shopacado-test-offer-name', testOfferName);
    
            let uri = window.location.toString();
            if (uri.indexOf("?") > 0) {
                let clean_uri = uri.substring(0, uri.indexOf("?"));
                window.history.replaceState({}, "", clean_uri);
            }
        }

        if (window.shopacado.interceptXMLHttpRequest) {
            XMLHttpRequest = new Proxy(XMLHttpRequest, {
                construct: function (target, args) {
                    const xhr = new target(...args);
                    // Do whatever you want with XHR request
                    xhr.onreadystatechange = async () => {
                        if (xhr.readyState === 1) {
                            // Before sent request to server
                            // console.log("shopacado XMLHttpRequest ready state 1", xhr._url);
                        }

                        if (xhr.readyState === 4) {
                            // After request completed
                            const handled = await handleXMLHttpRequestResponse(xhr);
                            // console.log("shopacado XMLHttpRequest ready state 4", xhr._url, handled);
                        }
                    };
                    // xhr.send = async (data) => {
                    //     console.log("shopacado XMLHttpRequest send", data);
                    //     XMLHttpRequest.prototype.send.call(xhr, data);
                    // }
                    return xhr;
                },
            });
        }

        (function(fetch) {
            window.fetch = function() {
                // console.log("shopacado fetch", arguments);
                const url = arguments[0];
                const data = arguments[1];

                return new Promise((resolve, reject) => {
                    fetch.apply(this, arguments)
                        .then(async (response) => {
                            if (response.status === 200) {
                                const handled = await handleAjaxResponse(url, data, response);
                                if (handled) {
                                    resolve(handled);
                                } else {
                                    resolve(response);
                                }
                            } else {
                                resolve(response);
                            }
                        })
                        .catch((error) => {
                            reject(error);
                        });
                });
            };
        }(window.fetch));

        window.shopacado.payload.multicurrency = {};
        if (window.Shopify && window.Shopify.currency) {
            window.shopacado.payload.multicurrency.currency = window.Shopify.currency.active;
            window.shopacado.payload.multicurrency.rate = window.Shopify.currency.rate;
            window.shopacado.payload.multicurrency.locale = window.Shopify.locale;
            window.shopacado.payload.multicurrency.country = window.Shopify.country;
        }

        insertCartSnippets();
        checkForTestOffer();
        if (!(window.shopacado.interceptCartChangeUrl && window.shopacado.is_cart_page) && (window.shopacado.interceptAjax)) {
            shopacadoCartGet();
        }
        
        if (window.shopacado.interceptCartChangeUrl && window.shopacado.is_cart_page) {
            const cartData = await shopacadoCartGet(2);
            const cartJson = await cartData.json();
            window.shopacado.log("cartData", cartJson);

            window.shopacado.responseStore.cartJS = cartJson;
            
            const reqeustDiscountsCookie = getCookie("shopacado-request-discounts");
            window.shopacado.log("requestDiscountsCookie", reqeustDiscountsCookie);
            if (reqeustDiscountsCookie && reqeustDiscountsCookie === "true") {
                !requestedDiscounts && requestDiscounts();
                requestedDiscounts = true;
                setCookieSession("shopacado-request-discounts", "false");
            } else {
                !requestedDiscounts && requestDiscounts(true);
                requestedDiscounts = true;
                setCookieSession("shopacado-request-discounts", "true");
            }
        } else if (window.shopacado.interceptXMLHttpRequest) {
            const cartData = await shopacadoCartGet(2);
            const cartJson = await cartData.json();
            window.shopacado.log("cartData", cartJson);

            window.shopacado.responseStore.cartJS = cartJson;
            updateCartItems();
        }
        
        if (window.shopacado.product && !requestedDiscounts) {
            console.log("requesting discounts for product");
            !requestedDiscounts && requestDiscounts(true);
            requestedDiscounts = true;
        }

        window.shopacado.cartUpdateHandler = (overrideDelay = false) => {
            setTimeout(() => {
                window.shopacado.log("cartUpdateHandler called");
                insertCartSnippets();
                updateCartItems();
            }, window.shopacado.themeSettings?.cart_update_detection?.delay || overrideDelay || 0);
        };
    });

}(window, document);
