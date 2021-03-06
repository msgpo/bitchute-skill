/*
 *  Copyright 2018 by Aditya Mehra <aix.m@outlook.com>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import QtQuick.Layouts 1.4
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.3
import org.kde.kirigami 2.8 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.components 2.0 as PlasmaComponents
import Mycroft 1.0 as Mycroft
import "+mediacenter/views" as Views
import "+mediacenter/delegates" as Delegates

Mycroft.Delegate {
    id: root
    property var videoListModel: sessionData.relatedVideoListBlob.videoList
    skillBackgroundSource: "https://source.unsplash.com/weekly?music"
    fillWidth: true
    
    onFocusChanged: {
        if(focus) {
            relatedVideoListView.view.forceActiveFocus()
        }
    }
    
    Keys.onBackPressed: {
        parent.parent.parent.currentIndex--
        parent.parent.parent.currentItem.contentItem.forceActiveFocus()
    }
    
    Connections {
        target: Mycroft.MycroftController
        onIntentRecevied: {
            if(type == "speak") {
                busyIndicatorPop.close()
                busyIndicate = false
            }
        }
    }
        
    Views.TileView {
        id: relatedVideoListView
        focus: true
        title: "Related Videos"
        model: videoListModel
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        cellWidth: view.width / 4
        cellHeight: cellWidth / 1.8 + Kirigami.Units.gridUnit * 5
        delegate: Delegates.VideoCardRelated{
            width: relatedVideoListView.cellWidth
            height: relatedVideoListView.cellHeight
        }
    }
    
    Popup {
        id: busyIndicatorPop
        width: parent.width
        height: parent.height
        background: Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.5)
        }
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        
        BusyIndicator {
            running: busyIndicate
            anchors.centerIn: parent
        }
        
        onOpened: {
            busyIndicate = true
        }
        
        onClosed: {
            busyIndicate = false
        }
    }
}
 
