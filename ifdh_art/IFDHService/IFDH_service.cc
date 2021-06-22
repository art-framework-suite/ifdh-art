#include "IFDH_service.h"
#include "messagefacility/MessageLogger/MessageLogger.h"
#include <iostream>
#include <vector>

namespace ifdh_ns {

IFDH::IFDH( fhicl::ParameterSet const & cfg )
{
  std::vector<std::string> const cfgkeys = cfg.get_names();
  std::string s;

  mf::LogVerbatim("test") << "IFDH constructor, got keys:";
  for (auto const& key : cfgkeys) {
       mf::LogVerbatim("test")<< key << ", ";
  }

  if ( cfg.get_if_present("IFDH_BASE_URI", s) ) {
      mf::LogVerbatim("test") << "IFDH: setting uri to:" << s << "\n";
      this->set_base_uri(s);
  } else {
      mf::LogVerbatim("test") << "IFDH: didn't find a base uri...\n";
  }
  if ( cfg.get_if_present("debug", s) ) {
      mf::LogVerbatim("test") << "IFDH: turning on debug\n";
      this->set_debug(s);
  }
}

}

DEFINE_ART_SERVICE(ifdh_ns::IFDH)
