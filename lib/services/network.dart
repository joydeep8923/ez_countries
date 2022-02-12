import 'dart:convert';

import 'package:countries/model/country_model.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Network {
  final HttpLink httpLink = HttpLink(
    'https://countries.trevorblades.com/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: () => "",
  );
  late Link link;
  late GraphQLClient client;
  CountryModel? countries;

  Network() {
    link = authLink.concat(httpLink);
    client = GraphQLClient(link: link, cache: GraphQLCache());
  }

  Future getAllCountries() async {
    final String query = '''
    query {
      countries {
        name
        emoji
        languages {
          code
          name
        }
      }
    }
  ''';
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(query),
      ),
    );

    return json.encode(result.data);
  }

  Future getLanguages() async {
    final String query = '''
    query Query {
      languages {
        name
        code
      }
    }
  ''';
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(query),
      ),
    );
    return json.encode(result.data!['languages']);
  }

  Future getCountryByCode(context, {String? code}) async {
    final String query = '''
    query Query {
      country(code: "$code") {
      name
      }
    }
  ''';
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(query),
      ),
    );
    if (result.hasException) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Country code doesn't exists"),
        backgroundColor: Colors.red,
      ));
      return null;
    }

    return json.encode(result.data);
  }
}
