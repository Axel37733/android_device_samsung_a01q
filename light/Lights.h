#pragma once
#include <aidl/android/hardware/light/BnLights.h>

namespace aidl::android::hardware::light {

class Lights : public BnLights {
  public:
    ndk::ScopedAStatus setLightState(int32_t id, const HwLightState& state) override;
    ndk::ScopedAStatus getLights(std::vector<HwLight>* types) override;
};

}  // namespace aidl::android::hardware::light
