/*
 * dry (Don't Repeat Yourself)
 *
 * Usage: `dry 300`
 *
 * Sets the key repeat interval without requiring a logout.
 */

#include <stdio.h>
#include <stdlib.h>
#include <IOKit/hidsystem/event_status_driver.h>

int main(int argc, const char * argv[]) {
    NXEventHandle handle;
    double interval;

    if (argc != 2) {
        printf("Expected 1 argument (key repeat in seconds); got %d\n", argc - 1);
        return EXIT_FAILURE;
    }

    handle = NXOpenEventStatus();
    if (!handle) {
        perror("NXOpenEventStatus");
        return EXIT_FAILURE;
    }

    interval = NXKeyRepeatInterval(handle);
    printf("Old interval: %lf\n", interval);

    sscanf(argv[1], "%lf", &interval);
    printf("New interval: %lf\n", interval);

    NXSetKeyRepeatInterval(handle, interval);
    return 0;
}
