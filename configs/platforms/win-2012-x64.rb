platform "win-2012-x64" do |plat|
  plat.vmpooler_template "win-2012r2-x86_64"


  plat.provision_with "echo provision_with choco install"
  plat.install_build_dependencies_with "echo build_dependencies choco install"
end
