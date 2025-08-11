import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Quickshell.Services.Pipewire
import "../../globals" as Globals

Item {
    id: audioModule

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

    // Timer to close popup on hover-out
    Timer {
        id: closePopupTimer
        interval: 200
        repeat: false
        onTriggered: audioPopup.close()
    }

    // Hover area to open the popup
    MouseArea {
        anchors.fill: mainDisplay
        hoverEnabled: true
        onEntered: {
            closePopupTimer.stop()
            audioPopup.open()
        }
        onExited: {
            closePopupTimer.start()
        }
    }

    // The popup that contains the controls
    Popup {
        id: audioPopup
        width: 120
        height: 180
        x: (parent.width - width) / 2
        y: -190 // Position above the main item
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: closePopupTimer.stop()
            onExited: closePopupTimer.start()
        }

        background: Rectangle {
            color: Globals.Colors.audio.background
            radius: 10
            border.color: "#cccccc"
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Mute Button
            Button {
                id: muteButton
                Layout.alignment: Qt.AlignHCenter
                text: node && node.audio && node.audio.muted ? "Unmute" : "Mute"
                onClicked: {
                    if (node && node.audio) {
                        node.audio.muted = !node.audio.muted;
                    }
                }
                
                background: Rectangle {
                    color: muteButton.pressed ? Qt.darker(muteButton.buttonColor) : muteButton.buttonColor
                    radius: 5
                }

                property color buttonColor: {
                    if (node && node.audio && node.audio.muted) {
                        return Globals.Colors.audio.muted;
                    } else {
                        return Globals.Colors.audio.unmuted;
                    }
                }
            }

            // Vertical Volume Slider
            Slider {
                id: volumeSlider
                Layout.fillWidth: true
                Layout.fillHeight: true
                orientation: Qt.Vertical
                value: node && node.audio ? node.audio.volume : 0

                onValueChanged: {
                    if (node && node.audio) {
                        node.audio.volume = value;
                    }
                }

                background: Rectangle {
                    x: volumeSlider.leftPadding + volumeSlider.padding
                    y: volumeSlider.topPadding
                    width: volumeSlider.availableWidth
                    height: volumeSlider.availableHeight
                    radius: 5
                    color: Globals.Colors.audio.sliderBackground
                }

                handle: Rectangle {
                    x: volumeSlider.leftPadding
                    y: volumeSlider.visualPosition * (volumeSlider.availableHeight - height)
                    width: volumeSlider.availableWidth + volumeSlider.padding * 2
                    height: 10
                    radius: 3
                    color: Globals.Colors.audio.volumeBar
                }
            }
        }
    }
}
