#include "IFCatalogInterface_service.h"
#include "art/Framework/Services/FileServiceInterfaces/FileDeliveryStatus.h"
#include "art/Framework/Services/FileServiceInterfaces/CatalogInterface.h"
#include "art/Framework/Services/Registry/ActivityRegistry.h"
#include "art/Framework/Services/Registry/ServiceMacros.h"
#include "art/Framework/Services/Registry/detail/ServiceHelper.h"

#include "messagefacility/MessageLogger/MessageLogger.h"

namespace ifdh_ns {


IFCatalogInterface::IFCatalogInterface(const fhicl::ParameterSet &cfg, __attribute__((unused)) art::ActivityRegistry& ar ) : 
    _process_id(""), 
    _proj_uri(""),
    _project_name(""), 
    _sam_station(""), 
    _last_file_uri("")
{ 
    std::vector<std::string> cfgkeys = cfg.get_keys();
    std::string s;

    mf::LogVerbatim("test") << "IFCatalogInterface constructor, got keys:";
    for (std::vector<std::string>::iterator p = cfgkeys.begin(); p != cfgkeys.end(
  ); p++ ) {
	 mf::LogVerbatim("test")<< *p << ", ";
    }

    if ( cfg.get_if_present("webURI", s) ) {
	mf::LogVerbatim("test") << "IFCatalogInterface: setting _proj_uri to:" << s << "\n";
	_proj_uri = s;
    }
}

IFCatalogInterface::~IFCatalogInterface() throw () { 
    mf::LogVerbatim("test") << "IFCatalogInterface destructor:";
    try {
	if( _last_file_uri.length() ) {
	    mf::LogVerbatim("test") << "IFCatalogInterface: updating file status in destructor";
	    // XXX should this be  art::FileDisposition::SKIPPED ???
	    // shouldn't we have updated the status already?
	    doUpdateStatus(_last_file_uri, art::FileDisposition::CONSUMED);
	}
	if( _proj_uri.length() &&  _process_id.length() ) {
	   _ifdh_handle->setStatus(_proj_uri, _process_id, "completed");
	}
    } catch (...) {
        // just ignore anything that goes wrong trying to set completed.
	mf::LogVerbatim("test") << "IFCatalogInterface: ignoring exception in destructor";
        ;
    }
}

void 
IFCatalogInterface::doConfigure(std::vector<std::string> const & item) {
    if (item.size() ) {
        _process_id = item[0]; 
       mf::LogVerbatim("test") << "IFCatalogInterface doConfigure, got id:" << item[0];
    }
}


int  
IFCatalogInterface::doGetNextFileURI(std::string & uri, __attribute__((unused)) double & waitTime) {
    mf::LogVerbatim("test") << "IFCatalogInterface entering doGetNextFile\n";
    if ( _last_file_uri.length() ) {
        mf::LogVerbatim("test") << "Updating status in doGetNextFile\n";
        // XXX should this be  art::FileDisposition::SKIPPED ???
        // shouldn't we have updated the status already?
        doUpdateStatus(_last_file_uri, art::FileDisposition::CONSUMED);
    }
    if ( _proj_uri.length())  {
	uri = _ifdh_handle->getNextFile(_proj_uri,_process_id);
        _last_file_uri = uri;
	if (uri.length()) {
            mf::LogVerbatim("test") << "doGetNextFile success\n";
	    return art::FileDeliveryStatus::SUCCESS;
	} else {
            mf::LogVerbatim("test") << "doGetNextFile no_more_files\n";
	    return art::FileDeliveryStatus::NO_MORE_FILES;
        }
    }
    return art::FileDeliveryStatus::BAD_REQUEST;
}

void 
IFCatalogInterface::doUpdateStatus(std::string const & uri, art::FileDisposition status) {
    static const char *statusmap[] = {
	"transferred",
	"consumed",
	"skipped",
	"consumed",  /* INCOMPLETE */
    };

    mf::LogVerbatim("test") << "IFCatalogInterface doUpdateStatus " << uri << " status: " << int(status) << "\n";

    if( _proj_uri.length()) {
        _ifdh_handle->updateFileStatus(_proj_uri,_process_id,uri,statusmap[int(status)]);
        if (status != art::FileDisposition::TRANSFERRED) {
           int res = unlink(_ifdh_handle->localPath(_last_file_uri).c_str());
           mf::LogVerbatim("test")  << "unlink of file returns:" << res  << "\n";
           _last_file_uri = "";
        }
    }
}

void 
IFCatalogInterface::doOutputFileOpened(std::string const & module_label) {
   mf::LogVerbatim("test")  << "IFCatalogInteface doOutputFileOpened: " << module_label << "\n";
   ;
}

void 
IFCatalogInterface::doOutputModuleInitiated(__attribute__((unused)) std::string const & module_label,
			       fhicl::ParameterSet const & pset) {
    std::string s;
    bool ignore = false;
    std::vector<std::string> cfgkeys = pset.get_keys();
    mf::LogVerbatim("test") << "IFCatalogInterface doOutputModuleInitiated, got keys:";
    for (std::vector<std::string>::iterator p = cfgkeys.begin(); p != cfgkeys.end(
  ); p++ ) {
	 mf::LogVerbatim("test")<< *p << ", ";
    }
}
     

void 
IFCatalogInterface::doOutputFileClosed(std::string const & module_label,
			  std::string const & fileFQname) {
     mf::LogVerbatim("test")  << "IFCatalogInteface doOutputFileClosed: " << module_label << ", " << fileFQname << "\n";
    // don't try to add filenames with % in them, they aren't real names.
    if (fileFQname.find('%') == std::string::npos) {
       _ifdh_handle->addOutputFile(fileFQname);
    }
    return;
}

void 
IFCatalogInterface::doEventSelected(__attribute((unused)) std::string const & module_label,
		       __attribute((unused)) art::EventID const & event_id,
		       __attribute((unused)) art::HLTGlobalStatus const & acceptance_info) {
    ;
}

bool
IFCatalogInterface::doIsSearchable() {
   return 0;
}

void
IFCatalogInterface::doRewind() {
   // throw NotImplemented;
   ;
}

}

//DEFINE_ART_SERVICE(ifdh_ns::IFCatalogInterface);
DEFINE_ART_SERVICE_INTERFACE_IMPL(ifdh_ns::IFCatalogInterface, art::CatalogInterface)
