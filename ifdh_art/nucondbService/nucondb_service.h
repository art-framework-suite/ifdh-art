#ifndef NUCONDBSERVICE_H
#define NUCONDBSERVICE_H
#include "nucondb.h"

// ART bits...
#include "fhiclcpp/ParameterSet.h"
#include "art/Framework/Services/Registry/ActivityRegistry.h"
#include "art/Framework/Services/Registry/ServiceHandle.h"
#include "art/Framework/Services/Registry/ServiceMacros.h"
#include "cetlib_except/exception.h"

namespace nucondb_ns {

class nucondbService  {
       
public:
        // ART constructor...
        nucondbService( fhicl::ParameterSet const & cfg, art::ActivityRegistry &r);
        std::unique_ptr<Folder> getFolder(std::string name, std::string url, std::string tag = "");
};

}

DECLARE_ART_SERVICE(nucondb_ns::nucondbService,LEGACY)

// this is redundant, given the include,  but just to be clear

using namespace nucondb_ns;
#endif // NUCONDBSERVICE_H
