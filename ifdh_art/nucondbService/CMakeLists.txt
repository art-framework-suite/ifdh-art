

simple_plugin(nucondb "service" 
			   ${NUCONDB} 
                           ${WDA}
                           ${IFDH}
			   art::Utilities
                           messagefacility::MF_MessageLogger
			   fhiclcpp::fhiclcpp
                           cetlib::cetlib
                           Boost::filesystem
              BASENAME_ONLY
        )

install_ifdh_headers()
install_source()

