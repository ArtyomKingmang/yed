import yed;
import std.stdio;
import std.file;
import std.algorithm;

void main() {

    auto graph = new Graph();
    

    auto node1 = graph.addNode(NodeStyle(
        text: "Node 1",
        x: 100,
        y: 100
    ));
    
    auto node2 = graph.addNode(NodeStyle(
        text: "Node 2",
        x: 200,
        y: 200
    ));
    

    graph.addEdge(node1, node2, EdgeStyle(
        text: "Edge 1-2"
    ));
    

    string filename = "test.graphml";
    graph.save(filename);
    

    
} 