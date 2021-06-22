#include "nucondb_service.h"

namespace nucondb_ns {


// ART constructor...
nucondbService::nucondbService( __attribute__((unused)) fhicl::ParameterSet const & cfg, __attribute__((unused)) art::ActivityRegistry &r) {}

std::unique_ptr<Folder> 
nucondbService::getFolder(std::string name, std::string url, std:: string tag ) { 
   std::unique_ptr<Folder> res(new Folder(name, url, tag));
   return res;
}

}

//DEFINE_ART_SERVICE(nucondb_ns::nucondbService)
DEFINE_ART_SERVICE(nucondb_ns::nucondbService)
