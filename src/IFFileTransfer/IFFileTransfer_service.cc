#include "messagefacility/MessageLogger/MessageLogger.h"
#include "art/Framework/Services/FileServiceInterfaces/FileTransferStatus.h"
#include "IFFileTransfer_service.h"


namespace ifdh_ns {

IFFileTransfer::IFFileTransfer(const fhicl::ParameterSet&, art::ActivityRegistry& ) {
}

int 
IFFileTransfer::doTranslateToLocalFilename( std::string const & uri, std::string & fileFQname) {
    mf::LogVerbatim("test") << "IFFileTransfer: entered for uri: " << uri << "\n";
    fileFQname = _ifdh_handle->fetchInput(uri);
    mf::LogVerbatim("test") << "IFFileTransfer: copied " << uri << " to " << fileFQname << "\n";
    return art::FileTransferStatus::SUCCESS;
}

}

DEFINE_ART_SERVICE_INTERFACE_IMPL(ifdh_ns::IFFileTransfer, art::FileTransfer)
