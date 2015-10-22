# Build Tools Path
TOOLCHAIN_DIR="/Users/Shared/PIC/toolchain"
ifndef XCTOOL
  XCTOOL=${TOOLCHAIN_DIR}/xctool/bin/xctool
endif

GCOV=${TOOLCHAIN_DIR}/gcovr


# PROJECT settings
CONFIGURATION_DEBUG=Debug
CONFIGURATION_RELEASE=Release
WORKSPACE=Allianz.xcworkspace
#BUILD_SCHEME=Allianz


ifeq ($(PROVISIONNING), APP_STORE)
  OTA_PROVISIONNING=./Allianz_Mobile_App_Store.mobileprovision
  GENERATED_IPA_BASENAME=Allianz mobile
  OTA_IDENTITY=iPhone Distribution: ALLIANZ IARD
else ifeq ($(PROVISIONNING), APP_STORE_WATCHKIT)
  OTA_PROVISIONNING=./Allianz_Mobile_Watch_App_Store.mobileprovision
  GENERATED_IPA_BASENAME=Allianz mobile
  OTA_IDENTITY=iPhone Distribution: ALLIANZ IARD
else ifeq ($(PROVISIONNING), IN_HOUSE)
  OTA_PROVISIONNING=./Mon_Allianz_Mobile_In_House.mobileprovision
  GENERATED_IPA_BASENAME=Allianz Mobile
  OTA_IDENTITY=iPhone Distribution: ALLIANZ I A R D
else ifeq ($(PROVISIONNING), PRE_RELEASE)
  OTA_PROVISIONNING=./Allianz_Mobile_Distribution_Adhoc.mobileprovision
  GENERATED_IPA_BASENAME=Allianz Mobile
  OTA_IDENTITY=iPhone Distribution: ALLIANZ IARD
else
  OTA_PROVISIONNING=./Allianz_Recette_Distribution_Adhoc.mobileprovision
  GENERATED_IPA_BASENAME=Allianz mobile Test
  OTA_IDENTITY=iPhone Distribution: ALLIANZ IARD
endif

# Directories & TEST/COVERAGE settings
BUILD_DIRECTORY=${PWD}/build
TEST_DIRECTORY=${PWD}/test-reports
GCOV_EXCLUDES=--exclude '.*Tests.*' --exclude '.*.*' --exclude '.*main.*' --exclude '.*AppDelegate.*' --exclude '.*NijiPods.*' --exclude '.*Pods.*' --exclude '.*Controllers.*' --exclude '.*Views.*' --exclude '.*Debugging.*' --exclude '.*UI.*'

DQUOTE="


######################
# Makefile Rules
######################

all: analysis tests coverage


build-ota: clean # Faire un build de l'application en s'assurant qu'on build pour device (iphoneos) et pas simulateur, et qu'on signe avec l'identité de distribution et non de développement
	-${XCTOOL} -workspace "${WORKSPACE}" -scheme $(BUILD_SCHEME) -configuration $(CONFIGURATION_RELEASE) -sdk iphoneos CODE_SIGN_IDENTITY="${OTA_IDENTITY}" CONFIGURATION_BUILD_DIR="${BUILD_DIRECTORY}" CERTIFICATE_PASSWORD='@\"${CERTIFICATE_PASSWORD}\"' BASE_URL='@\"${BASE_URL}\"' ECONSTAT_KEY='@\"${ECONSTAT_KEY}\"' build

#build-ota: clean # Faire un build de l'application en s'assurant qu'on build pour device (iphoneos) et pas simulateur, et qu'on signe avec l'identité de distribution et non de développement
#    -${XCTOOL} -workspace "${WORKSPACE}" -scheme $(BUILD_SCHEME) -configuration $(CONFIGURATION_RELEASE) -sdk iphoneos CODE_SIGN_IDENTITY="${OTA_IDENTITY}" CONFIGURATION_BUILD_DIR="${BUILD_DIRECTORY}" CERTIFICATE_PASSWORD='@\"${CERTIFICATE_PASSWORD}\"' BASE_URL='@\"${BASE_URL}\"' ECONSTAT_KEY='@\"${ECONSTAT_KEY}\"' build



package: keychain build-ota # Faire le packaging du .app généré en un .ipa, (et resigner le package avec la même identité de distribution)
	/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${BUILD_DIRECTORY}/${GENERATED_IPA_BASENAME}.app" -o "${BUILD_DIRECTORY}/${GENERATED_IPA_BASENAME}.ipa" --sign "${OTA_IDENTITY}" --embed "${OTA_PROVISIONNING}"

	"./pushOTA.sh" -q "${BUILD_DIRECTORY}/${GENERATED_IPA_BASENAME}.ipa"

keychain:
	# Use this to list active Keychains and valid identities found by the system to help debugging your code signing issues
	security unlock-keychain -p  ALLIANZ1 ~/Library/Keychains/login.keychain
	security list-keychains
	security find-identity
	security set-keychain-settings -t 900 -l ~/Library/Keychains/login.keychain

clean:

	${XCTOOL} -workspace "${WORKSPACE}" -scheme $(BUILD_SCHEME) clean

build: clean # keychain
	${XCTOOL} -workspace "${WORKSPACE}" -scheme $(BUILD_SCHEME) -configuration $(CONFIGURATION_DEBUG) -sdk iphoneos SYMROOT="${BUILD_DIRECTORY}" OBJROOT="${BUILD_DIRECTORY}" build

analysis: clean # keychain
	${XCTOOL} -workspace "${WORKSPACE}" -scheme $(BUILD_SCHEME) -configuration $(CONFIGURATION_DEBUG) -sdk iphoneos SYMROOT="${BUILD_DIRECTORY}" OBJROOT="${BUILD_DIRECTORY}" analyze

tests: clean
	-${XCTOOL} -workspace "${WORKSPACE}" -scheme $(BUILD_SCHEME) -configuration $(CONFIGURATION_DEBUG) -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO SYMROOT="${BUILD_DIRECTORY}" OBJROOT="${BUILD_DIRECTORY}" GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES -reporter junit:"${TEST_DIRECTORY}/junit-report.xml" -reporter pretty test -parallelize

coverage: tests
	${GCOV} -r . --object-directory "${BUILD_DIRECTORY}/$(BUILD_SCHEME).build/$(CONFIGURATION_DEBUG)-iphonesimulator/$(BUILD_SCHEME).build/Objects-normal/i386" ${GCOV_EXCLUDES} --xml > "${BUILD_DIRECTORY}/coverage.xml"

## Package and OTA ##
#fix-plist: scripts-update
	# Restore original Info.plist to avoid recursive changes if script called multiple times
	#svn revert "${INFO_PLIST}" 2&>/dev/null || (cd `dirname "${INFO_PLIST}"` ; git checkout `basename "${INFO_PLIST}"`)
	# Fix PLIST BundleIdentifier and Version
	#"${OTA_SCRIPTS_PATH}/fixInfoPlist.sh" -ifnotprefix com.niji. -identifier com.niji.% -version %-$(PLATFORM_NAME)-r@ "${INFO_PLIST}" 

