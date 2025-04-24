module yed;

import std.string;
import std.stdio;
import std.conv;

struct NodeStyle {
    string text = "";
    int x = 0;
    int y = 0;
    int width = 50;
    int height = 50;
    string fillColor = "#ffffff";
    string borderColor = "#000000";
    bool hasBorderColor = true;
    string borderWidth = "1";
    string fontFamily = "Arial";
    string fontSize = "12";
    string textColor = "#000000";
    string shape = "circle";
}

struct EdgeStyle {
    string text = "";
    bool directed = true;
    string lineColor = "#000000";
    string lineWidth = "1";
    string sourceArrow = "none";
    string targetArrow = "delta";
    string fontFamily = "Arial";
    string fontSize = "12";
    string textColor = "#000000";
}

class Graph {
    private int nodeId = 0;
    private string[] items;
    private NodeStyle defaultNodeStyle;
    private EdgeStyle defaultEdgeStyle;

    this() {
        defaultNodeStyle = NodeStyle();
        defaultEdgeStyle = EdgeStyle();
    }

    NodeStyle addNode(NodeStyle style) {
        auto nodeStyle = defaultNodeStyle;
        foreach (key, value; style.tupleof) {
            if (value != typeof(value).init) {
                nodeStyle.tupleof[key] = value;
            }
        }
        
        string nodeXml = format(`<node id="%d">
<data key="d0">
<y:ShapeNode>
<y:Geometry x="%d" y="%d" width="%d" height="%d"/>
<y:Fill color="%s"/>
<y:BorderStyle color="%s" width="%s" hasColor="%s"/>
<y:NodeLabel fontFamily="%s" fontSize="%s" alignment="center" textColor="%s">%s</y:NodeLabel>
<y:Shape type="%s"/>
</y:ShapeNode>
</data>
</node>`,
            nodeId,
            nodeStyle.x,
            nodeStyle.y,
            nodeStyle.width,
            nodeStyle.height,
            nodeStyle.fillColor,
            nodeStyle.borderColor,
            nodeStyle.borderWidth,
            nodeStyle.hasBorderColor ? "true" : "false",
            nodeStyle.fontFamily,
            nodeStyle.fontSize,
            nodeStyle.textColor,
            nodeStyle.text,
            nodeStyle.shape
        );
        
        items ~= nodeXml;
        nodeId++;
        return nodeStyle;
    }

    void addEdge(NodeStyle source, NodeStyle target, EdgeStyle style) {
        auto edgeStyle = defaultEdgeStyle;
        foreach (key, value; style.tupleof) {
            if (value != typeof(value).init) {
                edgeStyle.tupleof[key] = value;
            }
        }
        
        string edgeXml = format(`<edge directed="%s" source="%d" target="%d">
<data key="d1">
<y:PolyLineEdge>
<y:LineStyle color="%s" type="line" width="%s"/>
<y:Arrows source="%s" target="%s"/>
<y:EdgeLabel fontFamily="%s" fontSize="%s" alignment="center" textColor="%s">%s</y:EdgeLabel>
</y:PolyLineEdge>
</data>
</edge>`,
            edgeStyle.directed ? "true" : "false",
            source.x,
            target.x,
            edgeStyle.lineColor,
            edgeStyle.lineWidth,
            edgeStyle.sourceArrow,
            edgeStyle.targetArrow,
            edgeStyle.fontFamily,
            edgeStyle.fontSize,
            edgeStyle.textColor,
            edgeStyle.text
        );
        
        items ~= edgeXml;
    }

    void save(string filename) {
        string graphXml = `<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<graphml xmlns="http://graphml.graphdrawing.org/xmlns" xmlns:java="http://www.yworks.com/xml/yfiles-common/1.0/java" xmlns:sys="http://www.yworks.com/xml/yfiles-common/markup/primitives/2.0" xmlns:x="http://www.yworks.com/xml/yfiles-common/markup/2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:y="http://www.yworks.com/xml/graphml" xmlns:yed="http://www.yworks.com/xml/yed/3" xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns http://www.yworks.com/xml/schema/graphml/1.1/ygraphml.xsd">
<key for="node" id="d0" yfiles.type="nodegraphics"/>
<key for="edge" id="d1" yfiles.type="edgegraphics"/>
<graph id="G" edgedefault="directed">
` ~ items.join("\n") ~ `
</graph>
</graphml>`;

        auto file = File(filename, "w");
        file.write(graphXml);
        file.close();
    }
} 