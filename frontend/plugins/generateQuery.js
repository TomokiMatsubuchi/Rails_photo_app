// .gqlファイルをapiでリクエストをキャッチできる内容に整形
export default function generateQuery(query) {
  return query.loc.source.body;
}
