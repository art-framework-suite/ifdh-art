#ifndef IFDHSERVICE_H
#define IFDHSERVICE_H
#include "ifdh.h"

// art bits...
#include "fhiclcpp/ParameterSet.h"
#include "art/Framework/Services/Registry/ServiceMacros.h"

namespace ifdh_ns {

class IFDH : public ifdh {
public:

  // art constructor...
  IFDH( fhicl::ParameterSet const & cfg);

};

}

DECLARE_ART_SERVICE(ifdh_ns::IFDH, SHARED)

#endif // IFDHSERVICE_H
