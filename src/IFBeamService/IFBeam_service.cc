#include "IFBeam_service.h"

namespace ifbeam_ns {

IFBeam::IFBeam( fhicl::ParameterSet const & cfg, art::ActivityRegistry &r) {
     ;
}
        
std::unique_ptr<BeamFolder>
IFBeam::getBeamFolder(std::string bundle_name, std::string url, double time_width) {
    std::unique_ptr<BeamFolder> res(new BeamFolder(bundle_name, url, time_width));
    return res;
}
}

// DEFINE_ART_SERVICE(ifbeam_ns::IFBeam)
DECLARE_ART_SERVICE_INTERFACE(ifbeam_ns::IFBeam,LEGACY)

