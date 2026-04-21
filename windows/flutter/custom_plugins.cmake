# Project-controlled plugin list for Windows builds.
# Keep in sync with flutter/generated_plugins.cmake when dependencies change.

list(APPEND FLUTTER_PLUGIN_LIST
  cloud_firestore
  connectivity_plus
  file_selector_windows
  firebase_core
  firebase_storage
  printing
  sqlite3_flutter_libs
  url_launcher_windows
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/windows plugins/${plugin})

  # Hard-disable firebase_auth linkage on Windows to avoid unstable native path.
  if(plugin STREQUAL "cloud_firestore")
    if(TARGET cloud_firestore_plugin)
      get_target_property(_cloud_firestore_links cloud_firestore_plugin LINK_LIBRARIES)
      if(_cloud_firestore_links)
        list(REMOVE_ITEM _cloud_firestore_links firebase_auth)
        set_target_properties(cloud_firestore_plugin PROPERTIES LINK_LIBRARIES "${_cloud_firestore_links}")
      endif()
    endif()

    if(TARGET firebase_firestore)
      get_target_property(_firebase_firestore_iface firebase_firestore INTERFACE_LINK_LIBRARIES)
      if(_firebase_firestore_iface)
        list(REMOVE_ITEM _firebase_firestore_iface firebase_auth)
        set_target_properties(firebase_firestore PROPERTIES INTERFACE_LINK_LIBRARIES "${_firebase_firestore_iface}")
      endif()
    endif()
  endif()

  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)

foreach(ffi_plugin ${FLUTTER_FFI_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${ffi_plugin}/windows plugins/${ffi_plugin})
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${ffi_plugin}_bundled_libraries})
endforeach(ffi_plugin)

# Final guard: ensure the app target itself does not link firebase_auth.
if(TARGET ${BINARY_NAME})
  get_target_property(_app_links ${BINARY_NAME} LINK_LIBRARIES)
  if(_app_links)
    list(REMOVE_ITEM _app_links firebase_auth)
    set_target_properties(${BINARY_NAME} PROPERTIES LINK_LIBRARIES "${_app_links}")
  endif()
endif()
