import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import "components"
import "ui"


MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    id: mainView

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.majster-pl.socket-world"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
//    automaticOrientation: true

    width: units.gu(46)
    height: units.gu(75)

    //app main colors
    headerColor: "#88cc99"
    backgroundColor: "#88cccc"
    footerColor: "#88ccff"

    //Global VARS
    property string appMode: "phone"

    // JSON list with all countries
    JSONListModel {
        id: jsonMainDB
        source: Qt.resolvedUrl("mainDB.json")
        query: "$.root.countries[*]"
    }

    // JSON list with different Plugs&Sockets models
    JSONListModel {
        id: plugsMODEL
        source: Qt.resolvedUrl("mainDB.json")
        query: "$.root.plugs[*]"
     }

    // JSON list model to get application version from manifest file.
    JSONListModel {
        id: manifestMODEL
        source: Qt.resolvedUrl(".click/info/%1.manifest".arg(applicationName))
        query: "$"
    }

    // test JSONListModel
    JSONListModel {
        id: list_of_countries_plug_is_used
        source: Qt.resolvedUrl("mainDB.json")
        query: '$.root.countries[?(@.plug.value[0] == "A")]'
    }

    // time stamp function
    function time_stamp() {
        return Qt.formatDateTime(new Date(), "[dd/MM/yyyy hh:mm:ss] ")
    }

    onAppModeChanged: console.debug(time_stamp() + "mode switched to: " + appMode.toUpperCase())

    onWidthChanged: console.debug(time_stamp() + "width changed.")


    // Action for HUD
    actions: [
        // About in HUD
        Action {
            id: addCityAction
            text: i18n.tr("About")
            keywords: i18n.tr("More about this app.")
            description: "About dialog for Socket World"
            onTriggered: PopupUtils.open(aboutDialog)
        },
        Action {
            id: reportBugAction
            text: i18n.tr("Report Bug...")
            keywords: i18n.tr("How to report bugs.")
            description: "Dialog with information how to report bugs for this app."
            onTriggered: PopupUtils.open(bugReportDialog)
        }

    ]

    // About dialog
    AboutDialogComponent {
        id: aboutDialog
    }
    // Bug reporter
    BugReportDialogComponent {
        id: bugReportDialog
    }


// THIS IS MY TEST BUTTON ;)
//    Button {
//        text: "aaaaaa"
//        anchors.bottom: parent.bottom
//        onClicked: PopupUtils.open(aboutDialog)
////        onClicked: app_name_get()
//    }



    // Main tabs
    Tabs {
        id: tabs

        // ByLocationTab is a tab with all countries. default tab.
        ByLocationTab {
            id: byLocationTab
        }

        // ByPlugTypeTab is a tab with all plugs.
        ByPlugTypeTab {

        }
    }
}
