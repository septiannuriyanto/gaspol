enum KeywordFoundStatus {
  FOUND_ON_BOTH,
  FOUND_ON_RECEIVED,
  FOUND_ON_STOCK,
  NOT_FOUND_ON_BOTH
}

enum AutoCompleteType {
  ADD_ITEM,
  DISPLAY_LIST,
  DISPLAY_NULL_LIST,
  WAITING,
  DISPLAY_PARTIAL_LIST
}

enum ProcessType { RECEIVING, RETURNING, CHECKOUT, DONE }

enum SearchResult { EXACT, PARTIAL, NOTFOUND }

List<String> Locations = ["SUPPLIER", "SM", "WHEEL", "TRACK", "SSE"];
