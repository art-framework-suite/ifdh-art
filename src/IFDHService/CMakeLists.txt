

simple_plugin(IFDH service 
			   ${IFDH} 
			   art::Utilities
                           messagefacility::MF_MessageLogger
			   fhiclcpp::fhiclcpp
                           cetlib::cetlib ${CETLIB_EXCEPT}
                           Boost::filesystem
              BASENAME_ONLY
             )

install_ifdh_headers()
install_source()

