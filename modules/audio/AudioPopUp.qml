import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Quickshell.Services.Pipewire
import "../../globals" as Globals

Popup {
    id: audioPopup
    width: 120
    height: 180
    modal: true
    focus: true
    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape

    property var audioNode

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
            text: audioNode && audioNode.audio && audioNode.audio.muted ? "Unmute" : "Mute"
            onClicked: {
                if (audioNode && audioNode.audio) {
                    audioNode.audio.muted = !audioNode.audio.muted;
                }
            }
            
            background: Rectangle {
                color: muteButton.pressed ? Qt.darker(muteButton.buttonColor) : muteButton.buttonColor
                radius: 5
            }

            property color buttonColor: {
                if (audioNode && audioNode.audio && audioNode.audio.muted) {
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
            value: audioNode && audioNode.audio ? audioNode.audio.volume : 0

            onValueChanged: {
                if (audioNode && audioNode.audio) {
                    audioNode.audio.volume = value;
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
