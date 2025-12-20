#include <gps.h>
#include <stdio.h>

int main() {
    printf ("Running code ...!");
    struct gps_data_t gps;

    if (gps_open("localhost", "2947", &gps) != 0) {
        perror("gps_open");
        return 1;
    }

    gps_stream(&gps, WATCH_ENABLE | WATCH_JSON, NULL);

    while (1) {
        if (gps_waiting(&gps, 500000)) {
            if (gps_read(&gps, NULL, 0) > 0) {
                if (gps.fix.mode >= MODE_2D) {
                    printf("Lat: %f Lon: %f\n",
                        gps.fix.latitude,
                        gps.fix.longitude);
                }
            }
        }
    }
}
