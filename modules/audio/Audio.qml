import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Quickshell.Services.Pipewire
import "../../globals" as Globals
import "./AudioPopUp.qml"

Item {
    id: audioModule

    // This property allows the parent component to specify where the popup should be parented.
    // This is important for ensuring the popup can be displayed over other elements.
    property Item popupParent: parent

    // The node to control, in this case the default audio sink
    property PwNode node: Pipewire.defaultAudioSink

    // Use a PwObjectTracker to keep the node's properties up-to-date
    PwObjectTracker {
        objects: [audioModule.node]
    }

    // This is the main display that is always visible
    ColumnLayout {
        id: mainDisplay
        anchors.centerIn: parent
        spacing: 4
             Text {
            id: volumePercentage
            Layout.alignment: Qt.AlignHCenter
            text: node && node.audio ? `${Math.round(node.audio.volume * 100)}%` : "N/A"
            font.pixelSize: 14
            color: Globals.Colors.audio.text
        }

        Text {
            id: volumeIcon
            Layout.alignment: Qt.AlignHCenter
            text: {
                if (!node || !node.audio || node.audio.muted) return "🔇";
                if (node.audio.volume < 0.33) return "🔈";
                if (node.audio.volume < 0.66) return "🔉";
                return "🔊";
            }
            font.pixelSize: 18
            color: Globals.Colors.audio.text
        }
   
    }

    // Click area to open the popup
    MouseArea {
        anchors.fill: mainDisplay
        onClicked: {
            // We need to map the coordinates of our Audio module to the coordinate system
            // of the popup's parent. This ensures the popup appears in the correct location.
            var point = audioModule.mapToItem(popupParent, 0, 0)
            audioPopup.x = point.x + (audioModule.width - audioPopup.width) / 2
            audioPopup.y = point.y - audioPopup.height - 10
            audioPopup.open()
        }
    }

    AudioPopUp {
        id: audioPopup
        parent: popupParent
        audioNode: audioModule.node
    }
}
