//import { HttpLink } from 'apollo-link-http'
//
//export default () => {
//  const httpLink = new HttpLink({ uri: 'http://backend:3000/graphql' })
//  return {
//    link: httpLink
//  }
//}

export default function () {
  return {
    httpEndpoint: "http://backend:3000/graphql",
  };
}
