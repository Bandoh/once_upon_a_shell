import QtQuick 2.0
import QtQuick.Layouts
import Quickshell
import "../workspaces"
import "../wifi"
import "../audio"
import "../../globals" as Globals

PanelWindow {
    anchors {
        top: true
        left: true
        bottom: true
    }
    implicitWidth: 40
    margins {
        top: 10
        left: 0
        right: 0
        bottom: 10
    }

    color: Globals.Colors.background

    Rectangle {
        id: bar
        anchors.fill: parent
        color: Globals.Colors.background // fully transparent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 2
            spacing: 0

            // Workspaces Section
            Rectangle {
                color: Globals.Colors.workspaces.background
                Layout.fillWidth: true
                Layout.preferredHeight: workspaces.implicitHeight + 8
                radius: 10
                anchors.margins: 4

                Workspaces {
                    id: workspaces
                    anchors.fill: parent
                    anchors.margins: 4
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // // Wifi Section
            // Rectangle {
            //     color: Globals.Colors.wifi.background
            //     Layout.fillWidth: true
            //     Layout.preferredHeight: 60
            //     radius: 10
            //     anchors.margins: 4

            //     Wifi {
            //         anchors.fill: parent
            //         anchors.margins: 4
            //     }
            // }

            Item {
                Layout.fillWidth: true
                height: 20
            }

            // Audio Section
            Rectangle {
                color: Globals.Colors.audio.background
                Layout.fillWidth: true
                // Layout.preferredHeight: 40
                radius: 10
                anchors.margins: 4
                implicitHeight: myAudio.implicitHeight

                Audio {
                    id:myAudio
                    anchors.fill: parent
                    anchors.margins: 4
                    implicitHeight:50
                }   
            }
        }
    }
}
