import QtQuick 2.0
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "../../globals" as Globals

Item {
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 4

        // Volume control section
        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            // Mute button
            Rectangle {
                id: muteButton
                Layout.preferredWidth: 28
                Layout.preferredHeight: 28
                color: Pipewire.defaultAudioSink?.audio?.muted ? 
                       Globals.Colors.audio.muted : 
                       Globals.Colors.audio.unmuted
                radius: 6

                Text {
                    anchors.centerIn: parent
                    text: Pipewire.defaultAudioSink?.audio?.muted ? "🔇" : "🔊"
                    font.pixelSize: 14
                    color: Globals.Colors.audio.text
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (Pipewire.defaultAudioSink?.audio) {
                            Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
                        }
                    }
                }
            }
        }

        // Volume slider representation (visual indicator)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 6
            color: Globals.Colors.audio.sliderBackground
            radius: 3

            Rectangle {
                id: volumeIndicator
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * (Pipewire.defaultAudioSink?.audio?.volume || 0)
                height: parent.height
                color: Pipewire.defaultAudioSink?.audio?.muted ? 
                       Globals.Colors.audio.muted : 
                       Globals.Colors.audio.volumeBar
                radius: 3

                Behavior on width {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutQuad
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (Pipewire.defaultAudioSink?.audio) {
                        var newVolume = mouse.x / width
                        Pipewire.defaultAudioSink.audio.volume = Math.max(0, Math.min(1, newVolume))
                    }
                }
            }
        }

        // Volume percentage text
        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            text: Pipewire.defaultAudioSink?.audio ? 
                  Math.round((Pipewire.defaultAudioSink.audio.volume || 0) * 100) + "%" : 
                  "N/A"
            font.pixelSize: 10
            color: Globals.Colors.audio.text
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // Mouse wheel support for volume adjustment
    MouseArea {
        anchors.fill: parent
        onWheel: {
            if (Pipewire.defaultAudioSink?.audio) {
                var currentVolume = Pipewire.defaultAudioSink.audio.volume || 0
                var delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                var newVolume = Math.max(0, Math.min(1, currentVolume + delta))
                Pipewire.defaultAudioSink.audio.volume = newVolume
            }
        }
        // Allow events to propagate to child mouse areas
        propagateComposedEvents: true
    }
}
