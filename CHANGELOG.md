# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v4.0.0](https://github.com/voxpupuli/puppet-nomad/tree/v4.0.0) (2025-12-20)

[Full Changelog](https://github.com/voxpupuli/puppet-nomad/compare/v3.1.0...v4.0.0)

**Breaking changes:**

- Drop puppet, update openvox minimum version to 8.19 [\#130](https://github.com/voxpupuli/puppet-nomad/pull/130) ([TheMeier](https://github.com/TheMeier))
- Drop EoL Debian 10 [\#122](https://github.com/voxpupuli/puppet-nomad/pull/122) ([bastelfreak](https://github.com/bastelfreak))
- Drop EoL EL7 [\#121](https://github.com/voxpupuli/puppet-nomad/pull/121) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/stdlib: require 9.x [\#113](https://github.com/voxpupuli/puppet-nomad/pull/113) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- puppet/archive: Allow 8.x [\#129](https://github.com/voxpupuli/puppet-nomad/pull/129) ([TheMeier](https://github.com/TheMeier))
- metadata.json: Add OpenVox [\#125](https://github.com/voxpupuli/puppet-nomad/pull/125) ([jstraw](https://github.com/jstraw))
- puppet/systemd: allow 8.x [\#116](https://github.com/voxpupuli/puppet-nomad/pull/116) ([jay7x](https://github.com/jay7x))
- Add Debian 12 support [\#107](https://github.com/voxpupuli/puppet-nomad/pull/107) ([lbdemv](https://github.com/lbdemv))

**Closed issues:**

- create custom resource type to upload keys to nomad [\#87](https://github.com/voxpupuli/puppet-nomad/issues/87)

**Merged pull requests:**

- Cleanup .fixtures.yml [\#120](https://github.com/voxpupuli/puppet-nomad/pull/120) ([bastelfreak](https://github.com/bastelfreak))
- CI: Install Nomad 1.9.4 [\#119](https://github.com/voxpupuli/puppet-nomad/pull/119) ([bastelfreak](https://github.com/bastelfreak))

## [v3.1.0](https://github.com/voxpupuli/puppet-nomad/tree/v3.1.0) (2023-12-14)

[Full Changelog](https://github.com/voxpupuli/puppet-nomad/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- feat: Adding plugin\_dir management [\#100](https://github.com/voxpupuli/puppet-nomad/pull/100) ([attachmentgenie](https://github.com/attachmentgenie))

**Merged pull requests:**

- modulesync 7.2.0 [\#101](https://github.com/voxpupuli/puppet-nomad/pull/101) ([attachmentgenie](https://github.com/attachmentgenie))

## [v3.0.0](https://github.com/voxpupuli/puppet-nomad/tree/v3.0.0) (2023-08-21)

[Full Changelog](https://github.com/voxpupuli/puppet-nomad/compare/v2.2.0...v3.0.0)

**Breaking changes:**

- Drop Puppet 6 support [\#88](https://github.com/voxpupuli/puppet-nomad/pull/88) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add EL9 support [\#98](https://github.com/voxpupuli/puppet-nomad/pull/98) ([bastelfreak](https://github.com/bastelfreak))
- Add Rocky/AlmaLinux/OracleLinux support [\#97](https://github.com/voxpupuli/puppet-nomad/pull/97) ([bastelfreak](https://github.com/bastelfreak))
- Ubuntu: Add support for 22.04 [\#96](https://github.com/voxpupuli/puppet-nomad/pull/96) ([bastelfreak](https://github.com/bastelfreak))
- puppet/systemd: Allow 5.x [\#95](https://github.com/voxpupuli/puppet-nomad/pull/95) ([bastelfreak](https://github.com/bastelfreak))
- puppet/hashi\_stack: Allow 3.x [\#94](https://github.com/voxpupuli/puppet-nomad/pull/94) ([bastelfreak](https://github.com/bastelfreak))
- puppet/archive: Allow 7.x [\#93](https://github.com/voxpupuli/puppet-nomad/pull/93) ([bastelfreak](https://github.com/bastelfreak))
- Add Puppet 8 support [\#91](https://github.com/voxpupuli/puppet-nomad/pull/91) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/stdlib: Allow 9.x [\#90](https://github.com/voxpupuli/puppet-nomad/pull/90) ([bastelfreak](https://github.com/bastelfreak))
- Add config validate  [\#85](https://github.com/voxpupuli/puppet-nomad/pull/85) ([maxadamo](https://github.com/maxadamo))
- add peers.json and script to recover from outage [\#82](https://github.com/voxpupuli/puppet-nomad/pull/82) ([maxadamo](https://github.com/maxadamo))
- bump puppet/systemd to \< 5.0.0 [\#74](https://github.com/voxpupuli/puppet-nomad/pull/74) ([jhoblitt](https://github.com/jhoblitt))

**Closed issues:**

- add config validate [\#84](https://github.com/voxpupuli/puppet-nomad/issues/84)
- Nomad server recover helper [\#77](https://github.com/voxpupuli/puppet-nomad/issues/77)
- exec statement "reload nomad service" contains wrong command [\#75](https://github.com/voxpupuli/puppet-nomad/issues/75)

**Merged pull requests:**

- use systemd to reload the daemon [\#76](https://github.com/voxpupuli/puppet-nomad/pull/76) ([maxadamo](https://github.com/maxadamo))

## [v2.2.0](https://github.com/voxpupuli/puppet-nomad/tree/v2.2.0) (2023-01-07)

[Full Changelog](https://github.com/voxpupuli/puppet-nomad/compare/v2.1.0...v2.2.0)

**Implemented enhancements:**

- Allow overriding user and group used [\#71](https://github.com/voxpupuli/puppet-nomad/pull/71) ([jonasdemoor](https://github.com/jonasdemoor))
- Allow setting the data dir file mode [\#69](https://github.com/voxpupuli/puppet-nomad/pull/69) ([optiz0r](https://github.com/optiz0r))

## [v2.1.0](https://github.com/voxpupuli/puppet-nomad/tree/v2.1.0) (2022-05-23)

[Full Changelog](https://github.com/voxpupuli/puppet-nomad/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- Add fact for nomad\_node\_id [\#63](https://github.com/voxpupuli/puppet-nomad/pull/63) ([sebastianrakel](https://github.com/sebastianrakel))

**Merged pull requests:**

- extra\_options: default to undef instead of '' [\#64](https://github.com/voxpupuli/puppet-nomad/pull/64) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.0](https://github.com/voxpupuli/puppet-nomad/tree/v2.0.0) (2021-08-27)

[Full Changelog](https://github.com/voxpupuli/puppet-nomad/compare/v1.1.0...v2.0.0)

**Breaking changes:**

- Drop Debian 9; Add Debian 11 support [\#58](https://github.com/voxpupuli/puppet-nomad/pull/58) ([root-expert](https://github.com/root-expert))

**Merged pull requests:**

- add puppet-lint-param-docs [\#57](https://github.com/voxpupuli/puppet-nomad/pull/57) ([bastelfreak](https://github.com/bastelfreak))
- Allow up-to-date dependencies [\#55](https://github.com/voxpupuli/puppet-nomad/pull/55) ([smortex](https://github.com/smortex))
- switch from camptocamp/systemd to voxpupuli/systemd [\#54](https://github.com/voxpupuli/puppet-nomad/pull/54) ([bastelfreak](https://github.com/bastelfreak))
- Fix variable type in env\_vars documentation line [\#53](https://github.com/voxpupuli/puppet-nomad/pull/53) ([bplunkert](https://github.com/bplunkert))

## [v1.1.0](https://github.com/voxpupuli/puppet-nomad/tree/v1.1.0) (2021-05-14)

[Full Changelog](https://github.com/voxpupuli/puppet-nomad/compare/v1.0.0...v1.1.0)

**Implemented enhancements:**

- Add support for nomad.env file / Add nomad 1.0.5 support [\#50](https://github.com/voxpupuli/puppet-nomad/pull/50) ([bastelfreak](https://github.com/bastelfreak))

## [v1.0.0](https://github.com/voxpupuli/puppet-nomad/tree/v1.0.0) (2021-02-13)

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
