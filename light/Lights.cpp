#define LOG_TAG "lights-a01q"

#include "Lights.h"

#include <android-base/file.h>
#include <android-base/logging.h>
#include <android/binder_status.h>
#include <dirent.h>
#include <unistd.h>
#include <string>

namespace aidl::android::hardware::light {

static std::string FindBacklight() {
    static const char* kCands[] = {
        "/sys/class/leds/lcd-backlight",
        "/sys/class/backlight/panel0-backlight",
        "/sys/class/backlight/panel",
    };
    for (const char* c : kCands) {
        if (access((std::string(c) + "/brightness").c_str(), F_OK) == 0) return c;
    }
    DIR* d = opendir("/sys/class/backlight");
    if (d) {
        struct dirent* e;
        while ((e = readdir(d)) != nullptr) {
            if (e->d_name[0] == '.') continue;
            std::string p = std::string("/sys/class/backlight/") + e->d_name;
            if (access((p + "/brightness").c_str(), F_OK) == 0) {
                closedir(d);
                return p;
            }
        }
        closedir(d);
    }
    return "";
}

static int ReadMax(const std::string& dir) {
    std::string s;
    int m = 0;
    if (::android::base::ReadFileToString(dir + "/max_brightness", &s)) m = atoi(s.c_str());
    return m > 0 ? m : 255;
}

ndk::ScopedAStatus Lights::setLightState(int32_t id, const HwLightState& state) {
    if (id != 0) return ndk::ScopedAStatus::fromExceptionCode(EX_UNSUPPORTED_OPERATION);
    static const std::string dir = FindBacklight();
    if (dir.empty()) {
        LOG(ERROR) << "no backlight node found";
        return ndk::ScopedAStatus::fromExceptionCode(EX_UNSUPPORTED_OPERATION);
    }
    static const int maxBr = ReadMax(dir);
    uint32_t c = static_cast<uint32_t>(state.color) & 0x00ffffff;
    int r = (c >> 16) & 0xff, g = (c >> 8) & 0xff, b = c & 0xff;
    int br = (77 * r + 150 * g + 29 * b) >> 8;
    int v = br * maxBr / 255;
    if (br > 0 && v == 0) v = 1;
    if (!::android::base::WriteStringToFile(std::to_string(v), dir + "/brightness")) {
        PLOG(ERROR) << "write brightness failed";
        return ndk::ScopedAStatus::fromExceptionCode(EX_UNSUPPORTED_OPERATION);
    }
    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Lights::getLights(std::vector<HwLight>* lights) {
    HwLight l;
    l.id = 0;
    l.ordinal = 0;
    l.type = LightType::BACKLIGHT;
    lights->push_back(l);
    return ndk::ScopedAStatus::ok();
}

}  // namespace aidl::android::hardware::light
