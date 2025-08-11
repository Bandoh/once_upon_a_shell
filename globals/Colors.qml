pragma Singleton
import QtQuick 2.0

QtObject {
    // General colors for a light theme with an orange primary
    property color background: "transparent"


    // Group for workspace-specific colors
    property QtObject workspaces: QtObject {
        property color background: "#a0f0f0f0" // A very light gray
        property color active: "#ff7a00" // The main orange accent color
        property color focused: "#a0ff40" // Bright green
        property color hasUrgent: "#ff4040" // Red
        property color text: "#333333" // Dark gray for readability
    }

    property QtObject audio: QtObject {
        property color background: "#f9f0f0f0" // A very light gray
        property color muted: "#a0f81f1f" // A very light gray
        property color unmuted: "#7ad117" // A very light gray
        property color text: "#a0000000"
        property color sliderBackground:"#a0f0f0f0"
        property color volumeBar:"#a0eac10d"
    }

    property QtObject wifi: QtObject {
        property color background: "#a0f0f0f0" // A very light gray

    }
}