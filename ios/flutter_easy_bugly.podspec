#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_easy_bugly.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_easy_bugly'
  s.version          = '0.0.1'
  s.summary          = '为移动开发者提供专业的异常上报和运营统计，帮助开发者快速发现并解决异常，同时掌握产品运营动态，及时跟进用户反馈'
  s.description      = <<-DESC
为移动开发者提供专业的异常上报和运营统计，帮助开发者快速发现并解决异常，同时掌握产品运营动态，及时跟进用户反馈
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  s.static_framework = true
  s.dependency 'Bugly', '2.6.1'

  # Bugly 2.6.1 has no arm64 simulator slice. Build an empty simulator-only
  # framework with the same module name and put it before the real framework
  # in the simulator search path. Device builds continue to link the official
  # Bugly framework.
  s.preserve_paths = 'SimulatorStub/BuglyStub.c'
  s.script_phase = {
    :name => 'Build Bugly Simulator Stub',
    :execution_position => :before_compile,
    :script => <<-SCRIPT,
      if [ "${PLATFORM_NAME}" != "iphonesimulator" ]; then
        exit 0
      fi

      STUB_ROOT="${PODS_CONFIGURATION_BUILD_DIR}/BuglySimulatorStub"
      STUB_FRAMEWORK="${STUB_ROOT}/Bugly.framework"
      mkdir -p "${STUB_FRAMEWORK}"

      set --
      for ARCH in ${ARCHS}; do
        OBJECT_FILE="${TARGET_TEMP_DIR}/BuglyStub-${ARCH}.o"
        LIBRARY_FILE="${TARGET_TEMP_DIR}/libBuglyStub-${ARCH}.a"
        xcrun --sdk iphonesimulator clang \
          -arch "${ARCH}" \
          -isysroot "${SDKROOT}" \
          -mios-simulator-version-min="${IPHONEOS_DEPLOYMENT_TARGET}" \
          -c "${PODS_TARGET_SRCROOT}/SimulatorStub/BuglyStub.c" \
          -o "${OBJECT_FILE}"
        xcrun libtool -static -o "${LIBRARY_FILE}" "${OBJECT_FILE}"
        set -- "$@" "${LIBRARY_FILE}"
      done

      xcrun lipo -create "$@" -output "${STUB_FRAMEWORK}/Bugly"
    SCRIPT
    :output_files => ['$(PODS_CONFIGURATION_BUILD_DIR)/BuglySimulatorStub/Bugly.framework/Bugly']
  }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'FRAMEWORK_SEARCH_PATHS[sdk=iphonesimulator*]' => '"$(PODS_CONFIGURATION_BUILD_DIR)/BuglySimulatorStub" $(inherited)',
  }
  s.user_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS[sdk=iphonesimulator*]' => '"$(PODS_CONFIGURATION_BUILD_DIR)/BuglySimulatorStub" $(inherited)',
  }
  s.swift_version = '5.0'
end
