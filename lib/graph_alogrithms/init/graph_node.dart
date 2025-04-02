
enum NodeType { USER, ORGANIZATION, POST, HASHTAG ,COMMENT}

class GraphNode {

  String? nid;
  NodeType type;

  GraphNode(this.nid, this.type);

}



enum EdgeType {
  FOLLOWS,
  FOLLOWS_ORG,
  WORKS_AT,
  FOLLOWS_HASHTAG,
  POSTED,
  HAS_HASHTAG,
  LIKED,
  COMMENTED
}

class GraphEdge {
  GraphNode from;
  GraphNode to;
  EdgeType type;

  GraphEdge(this.from, this.to, this.type);
}
