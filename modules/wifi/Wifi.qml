import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

// WiFi Module for Bar
Rectangle {
    id: wifiModule
    width: 100
    height: 30
    color: "transparent"
    
    property string currentSsid: "Not Connected"
    property int signalStrength: 0
    property bool connected: false
    property bool scanning: false
    property var availableNetworks: []
    
    // Network manager process to get WiFi status
    Process {
        id: nmcliProcess
        command: ["nmcli", "-t", "-f", "ACTIVE,SSID,SIGNAL", "dev", "wifi"]
        running: true
        
        onStdoutChanged: {
            if (stdout) {
                parseWifiStatus(stdout);
            }
        }
    }
    
    // Timer to refresh WiFi status every 5 seconds
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            nmcliProcess.running = true
        }
    }
    
    // Function to parse nmcli output
    function parseWifiStatus(output) {
        const lines = output.trim().split('\n');
        wifiModule.connected = false;
        wifiModule.availableNetworks = [];
        
        for (let line of lines) {
            const parts = line.split(':');
            if (parts.length >= 3) {
                const active = parts[0] === 'yes';
                const ssid = parts[1];
                const signal = parseInt(parts[2]) || 0;
                
                if (active && ssid !== '') {
                    wifiModule.connected = true;
                    wifiModule.currentSsid = ssid;
                    wifiModule.signalStrength = signal;
                }
                
                if (ssid !== '') {
                    wifiModule.availableNetworks.push({
                        ssid: ssid,
                        signal: signal,
                        active: active
                    });
                }
            }
        }
    }
    
    // Get WiFi icon based on signal strength
    function getWifiIcon() {
        if (!connected) return "📶"; // No connection
        if (signalStrength >= 75) return "📶"; // Excellent
        if (signalStrength >= 50) return "📶"; // Good  
        if (signalStrength >= 25) return "📶"; // Fair
        return "📶"; // Weak
    }
    
    // Get signal strength color
    function getSignalColor() {
        if (!connected) return "#666666";
        if (signalStrength >= 75) return "#00ff00"; // Green
        if (signalStrength >= 50) return "#ffff00"; // Yellow
        if (signalStrength >= 25) return "#ff8800"; // Orange
        return "#ff0000"; // Red
    }
    
    RowLayout {
        anchors.fill: parent
        spacing: 5
        
        // WiFi Icon
        Text {
            text: getWifiIcon()
            color: getSignalColor()
            font.pixelSize: 16
        }
        
        // Connection Info
        Column {
            Layout.fillWidth: true
            
            Text {
                text: connected ? currentSsid : "Disconnected"
                color: connected ? "#ffffff" : "#666666"
                font.pixelSize: 10
                font.bold: true
                elide: Text.ElideRight
                width: parent.width
            }
            
            Text {
                text: connected ? signalStrength + "%" : ""
                color: getSignalColor()
                font.pixelSize: 8
                visible: connected
            }
        }
    }
    
    // Click area for interaction
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        
        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                // Left click: toggle connection or refresh
                if (connected) {
                    nmcliProcess.running = true;
                } else {
                    connectToWifi();
                }
            } else if (mouse.button === Qt.RightButton) {
                // Right click: show available networks
                showNetworkMenu();
            }
        }
    }
    
    // Additional processes for WiFi management
    Process {
        id: connectionEditorProcess
        command: ["nm-connection-editor"]
    }
    
    Process {
        id: scanProcess
        command: ["nmcli", "dev", "wifi", "rescan"]
        // onFinished: {
        //     scanning = false;
        //     nmcliProcess.running = true; // Refresh the list
        // }
    }
    
    Process {
        id: connectProcess
        command: []
    }
    
    Process {
        id: disconnectProcess
        command: []
    }
    
    // Functions for WiFi management
    function connectToWifi() {
        // Start network manager GUI or custom connection dialog
        connectionEditorProcess.running = true;
    }
    
    function showNetworkMenu() {
        console.log("Available Networks:");
        for (let network of availableNetworks) {
            console.log(`- ${network.ssid} (${network.signal}%) ${network.active ? '[Connected]' : ''}`);
        }
    }
    
    // Scan for networks
    function scanNetworks() {
        scanning = true;
        scanProcess.running = true;
    }
    
    // Connect to specific network (requires password handling)
    function connectToNetwork(ssid) {
        connectProcess.command = ["nmcli", "dev", "wifi", "connect", ssid];
        connectProcess.running = true;
    }
    
    // Disconnect from current network  
    function disconnect() {
        if (connected) {
            disconnectProcess.command = ["nmcli", "connection", "down", currentSsid];
            disconnectProcess.running = true;
        }
    }
    
    // Initialize
    Component.onCompleted: {
        nmcliProcess.running = true;
    }
}
