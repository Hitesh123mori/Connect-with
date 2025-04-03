
enum NodeType { USER, ORGANIZATION, POST, HASHTAG ,COMMENT}

class GraphNode {
  final String nid;
  final NodeType type;

  GraphNode(this.nid, this.type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is GraphNode && other.nid == nid && other.type == type);

  @override
  int get hashCode => nid.hashCode ^ type.hashCode;
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
