#ifndef IFBEAMSERVICE_H
#define IFBEAMSERVICE_H
#include "ifbeam.h"
#include <memory>

#include "fhiclcpp/ParameterSet.h"
#include "art/Framework/Services/Registry/ActivityRegistry.h"
#include "art/Framework/Services/Registry/ServiceMacros.h"


namespace ifbeam_ns {

class IFBeam  {
       
public:
        
        std::unique_ptr<BeamFolder> getBeamFolder(std::string bundle_name, std::string url = "", double time_width = 1200.0);

        // ART constructor...
        IFBeam( fhicl::ParameterSet const & cfg, art::ActivityRegistry &r);
};

}


DECLARE_ART_SERVICE(ifbeam_ns::IFBeam, LEGACY)
// this is redundant, given the ifbeam include,  but just to be clear

using namespace ifbeam_ns;
#endif // IFBEAMSERVICE_H
