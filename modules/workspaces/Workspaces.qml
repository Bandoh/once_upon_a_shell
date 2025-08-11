import QtQuick 2.0
import Quickshell.Hyprland
import "../../globals" as Globals

Column {
    id: workspaceColumn
    spacing: 2
    
    Repeater {
        model: Hyprland.workspaces
        
        Rectangle {
            width: parent.width
            height:{
                {
                if (modelData.focused) return 44
                if (modelData.active) return parent.width
                if (modelData.hasUrgent) return parent.width/2
                return parent.width
            }
            }
            radius: 14
            
            // Color based on workspace state
            color: {
                if (modelData.focused) return Globals.Colors.workspaces.focused
                if (modelData.active) return Globals.Colors.workspaces.active
                if (modelData.hasUrgent) return Globals.Colors.workspaces.hasUrgent
                return "#404040"
            }
            
            border.color: modelData.focused ? "#7be028" : "transparent"
            border.width: 2
            
            // Text {
            //     anchors.centerIn: parent
            //     text: modelData.name || modelData.id
            //     color: {
            //         if (modelData.focused) return "#000000"
            //         if (modelData.active) return "#000000"
            //         return "#ffffff"
            //     }
            //     font.pixelSize: 10
            //     font.bold: modelData.focused
            // }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    modelData.focus()
                }
                
                hoverEnabled: true
                onEntered: parent.opacity = 0.8
                onExited: parent.opacity = 1.0
            }
            
            // Show indicator if workspace has fullscreen window
            Rectangle {
                visible: modelData.hasFullscreen
                width: 6
                height: 6
                radius: 3
                color: "#ff9500"
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 2
            }
        }
    }
}