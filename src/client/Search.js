import React, { Component } from "react";
import { Container, Jumbotron, Row, Col } from "react-bootstrap";
import Header from "./Components/Header/Header.js";
import { retrieveCookie } from "./Components/Cookies";

export default class Home extends Component {
  constructor(props) {
    super(props);
    this.state = {
      user: retrieveCookie(),
      searchResults: [],
    };
    this.getResults();
    this.validSearch = this.validSearch.bind(this);
  }

  latestImages() {
    const results = [];

    for (let i = 0; i < this.state.searchResults.length; i++) {
      results.push(
        <Col className="post-card">
          <PostCard
            postid={this.state.searchResults[i]}
            userid={this.state.user}
          />
        </Col>
      );
    }
    return results;
  }

  getResults() {
    fetch(
      `http://192.168.1.153:4000/images/searchPosts/${this.props.match.params.searchParams}`,
      {
        method: "GET",
        credentials: "same-origin",
        headers: {
          "Content-Type": "application/json",
        },
      }
    )
      .then((response) => response.json())
      .then((res) => {
        this.setState(
          {
            searchResults: res.searchResults,
          },
          () => console.log()
        );
      });
  }

  validSearch() {
    if (this.props.match.params.searchParams.length > 2) {
      return (
        <Container fluid>
          <h1>
            Search Results matching {this.props.match.params.searchParams}
          </h1>
          <p />
          <Row className="justify-content-center">{this.latestImages()}</Row>
        </Container>
      );
    }
    return (
      <Jumbotron>
        <h1>Hmmm...</h1>
        <p>
          {" "}
          Your search is not valid. Try a longer search of at least 3 characters
          next time.
        </p>
      </Jumbotron>
    );
  }

  render() {
    return <div>{this.validSearch()}</div>;
  }
}
