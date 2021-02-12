# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v1.0.0](https://github.com/voxpupuli/puppet-nomad/tree/v1.0.0) (2021-02-12)

[Full Changelog](https://github.com/voxpupuli/puppet-nomad/compare/v0.0.4...v1.0.0)

**Breaking changes:**

- Aligning with upstream package layout, stdlib::to\_json and install method [\#48](https://github.com/voxpupuli/puppet-nomad/pull/48) ([attachmentgenie](https://github.com/attachmentgenie))
- removing os x  support [\#47](https://github.com/voxpupuli/puppet-nomad/pull/47) ([attachmentgenie](https://github.com/attachmentgenie))
- adding the option to setup the upstream HashiCorp repository [\#40](https://github.com/voxpupuli/puppet-nomad/pull/40) ([attachmentgenie](https://github.com/attachmentgenie))

**Closed issues:**

- Default config is not in sync with upstream defaults [\#45](https://github.com/voxpupuli/puppet-nomad/issues/45)
- user and group are not used [\#44](https://github.com/voxpupuli/puppet-nomad/issues/44)
- Add support for puppet 7 [\#43](https://github.com/voxpupuli/puppet-nomad/issues/43)
- Remove the environmentFile from service file [\#39](https://github.com/voxpupuli/puppet-nomad/issues/39)
- add option to manage the upstream repo [\#35](https://github.com/voxpupuli/puppet-nomad/issues/35)
- clean up init.pp params [\#34](https://github.com/voxpupuli/puppet-nomad/issues/34)
- get systemd file in sync with upstream version [\#33](https://github.com/voxpupuli/puppet-nomad/issues/33)
- nomad.service file large changes after upgrading to 0.0.4 [\#32](https://github.com/voxpupuli/puppet-nomad/issues/32)
- Do not monkey patch JSON function [\#23](https://github.com/voxpupuli/puppet-nomad/issues/23)
- Push puppet module 0.0.4 to forge [\#20](https://github.com/voxpupuli/puppet-nomad/issues/20)

**Merged pull requests:**

- Adding puppet 7 support [\#46](https://github.com/voxpupuli/puppet-nomad/pull/46) ([attachmentgenie](https://github.com/attachmentgenie))
- Init.pp cleanup; bump nomand 1.0.1 -\> 1.0.2 [\#42](https://github.com/voxpupuli/puppet-nomad/pull/42) ([attachmentgenie](https://github.com/attachmentgenie))
- Service file cleanup [\#41](https://github.com/voxpupuli/puppet-nomad/pull/41) ([attachmentgenie](https://github.com/attachmentgenie))
- adding OOMScoreAdjust from upstream PR https://github.com/hashicorp/n… [\#38](https://github.com/voxpupuli/puppet-nomad/pull/38) ([star3am](https://github.com/star3am))
- README.md: Add badges and fix links [\#31](https://github.com/voxpupuli/puppet-nomad/pull/31) ([bastelfreak](https://github.com/bastelfreak))

## [v0.0.4](https://github.com/voxpupuli/puppet-nomad/tree/v0.0.4) (2021-01-07)

[Full Changelog](https://github.com/voxpupuli/puppet-nomad/compare/0.0.2...v0.0.4)

**Closed issues:**

- Syntax error on README.md :\) [\#22](https://github.com/voxpupuli/puppet-nomad/issues/22)
- donate this module to voxpupuli [\#21](https://github.com/voxpupuli/puppet-nomad/issues/21)
- Add `CONSUL_HTTP_SSL` to systemd unit file [\#19](https://github.com/voxpupuli/puppet-nomad/issues/19)
- Migrate this module to Vox Pupuli [\#18](https://github.com/voxpupuli/puppet-nomad/issues/18)
- Reason to not support armv7l [\#17](https://github.com/voxpupuli/puppet-nomad/issues/17)
- Cannot create /etc/sysconfig/nomad [\#10](https://github.com/voxpupuli/puppet-nomad/issues/10)
- Replace puppet-staging with puppet-archive [\#7](https://github.com/voxpupuli/puppet-nomad/issues/7)

**Merged pull requests:**

- prepare for 0.0.4 release [\#30](https://github.com/voxpupuli/puppet-nomad/pull/30) ([attachmentgenie](https://github.com/attachmentgenie))
- Remove private class parameters [\#29](https://github.com/voxpupuli/puppet-nomad/pull/29) ([ekohl](https://github.com/ekohl))
- Documenting remaining params and example to puppet-strings tags [\#27](https://github.com/voxpupuli/puppet-nomad/pull/27) ([attachmentgenie](https://github.com/attachmentgenie))
- renaming to puppet-nomad in the vox namespace, updating dependencies … [\#26](https://github.com/voxpupuli/puppet-nomad/pull/26) ([attachmentgenie](https://github.com/attachmentgenie))
- modulesync 4.0.0-8-g292033c [\#25](https://github.com/voxpupuli/puppet-nomad/pull/25) ([attachmentgenie](https://github.com/attachmentgenie))
- Porting functions to the modern Puppet 4.x API [\#16](https://github.com/voxpupuli/puppet-nomad/pull/16) ([binford2k](https://github.com/binford2k))
- ensure latest is often unwanted [\#15](https://github.com/voxpupuli/puppet-nomad/pull/15) ([attachmentgenie](https://github.com/attachmentgenie))
- example doesnt show valid puppet code [\#14](https://github.com/voxpupuli/puppet-nomad/pull/14) ([attachmentgenie](https://github.com/attachmentgenie))
- switching to upstream module to configure systemd service file [\#13](https://github.com/voxpupuli/puppet-nomad/pull/13) ([attachmentgenie](https://github.com/attachmentgenie))
- Update version and add version parameter [\#12](https://github.com/voxpupuli/puppet-nomad/pull/12) ([LEDfan](https://github.com/LEDfan))
- update systemd service [\#11](https://github.com/voxpupuli/puppet-nomad/pull/11) ([damoun](https://github.com/damoun))
- Replace 'staging' puppet module with 'archive' [\#8](https://github.com/voxpupuli/puppet-nomad/pull/8) ([herver](https://github.com/herver))
- Nomad has arm builds, adding it to the $arch case [\#6](https://github.com/voxpupuli/puppet-nomad/pull/6) ([ncorrare](https://github.com/ncorrare))
- correct var file setting for systemd [\#5](https://github.com/voxpupuli/puppet-nomad/pull/5) ([vamitrou](https://github.com/vamitrou))
- Remove code to install Nomad UI \(there is no UI for Nomad\) [\#4](https://github.com/voxpupuli/puppet-nomad/pull/4) ([mmickan](https://github.com/mmickan))
- nomad agent does not have a -pid-file option [\#3](https://github.com/voxpupuli/puppet-nomad/pull/3) ([phpwutz](https://github.com/phpwutz))

## [0.0.2](https://github.com/voxpupuli/puppet-nomad/tree/0.0.2) (2016-03-30)

[Full Changelog](https://github.com/voxpupuli/puppet-nomad/compare/d7f26af180862351c719a15c532aa843d5323bb3...0.0.2)

**Merged pull requests:**

- pass $nomad::init\_style [\#2](https://github.com/voxpupuli/puppet-nomad/pull/2) ([phpwutz](https://github.com/phpwutz))
- Changing systemd CentOS7 init script [\#1](https://github.com/voxpupuli/puppet-nomad/pull/1) ([gangsta](https://github.com/gangsta))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
