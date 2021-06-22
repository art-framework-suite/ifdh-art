#ifndef IFFILETRANSFER_H
#define IFFILETRANSFER_H

#include "art/Framework/Services/Registry/ActivityRegistry.h"
#include "art/Framework/Services/Registry/ServiceHandle.h"
#include "fhiclcpp/ParameterSet.h"
#include "art/Framework/Services/Registry/ServiceMacros.h"
#include "art/Framework/Services/FileServiceInterfaces/FileTransfer.h"

#include "IFDH_service.h"

namespace ifdh_ns {

class IFFileTransfer : public art::FileTransfer {

public:
  IFFileTransfer(const fhicl::ParameterSet&, art::ActivityRegistry& );

private:
  art::ServiceHandle<IFDH> _ifdh_handle;
  virtual int doTranslateToLocalFilename(std::string const & uri,
                             std::string & fileFQname);
};

}
DECLARE_ART_SERVICE_INTERFACE_IMPL(ifdh_ns::IFFileTransfer, art::FileTransfer, SHARED)

#endif //IFFILETRANSFER_H
