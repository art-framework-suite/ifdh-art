#include "IFBeam_service.h"

namespace ifbeam_ns {

IFBeam::IFBeam( __attribute__((unused)) fhicl::ParameterSet const & cfg, __attribute__((unused)) art::ActivityRegistry &r) {
     ;
}
        
std::unique_ptr<BeamFolder>
IFBeam::getBeamFolder(std::string bundle_name, std::string url, double time_width) {
    std::unique_ptr<BeamFolder> res(new BeamFolder(bundle_name, url, time_width));
    return res;
}
}

// DEFINE_ART_SERVICE(ifbeam_ns::IFBeam)
DEFINE_ART_SERVICE(ifbeam_ns::IFBeam)

