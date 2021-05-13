import React, { Component } from "react";
import { Container, Jumbotron, Row, Col } from "react-bootstrap";
import Header from "./Components/Header/Header.js";
import { retrieveCookie } from "./Components/Cookies";

export default class Home extends Component {
  constructor(props) {
    super(props);
    this.state = {
      user: retrieveCookie(),
      latestImages: [],
    };
    // this.getLatest();
  }

  // latestImages() {
  //   const latest = [];
  //   console.log(this.state.latestImages);
  //   for (let i = 0; i < this.state.latestImages.length; i++) {
  //     latest.push(
  //       <Col className="post-card">
  //         <PostCard postid={this.state.latestImages[i]} />
  //       </Col>
  //     );
  //   }
  //   return latest;
  // }

  // getLatest() {
  //   fetch("http://localhost:4000/images/latest", {
  //     method: "GET",
  //     credentials: "same-origin",
  //     headers: {
  //       "Content-Type": "application/json"
  //     }
  //   })
  //     .then(response => response.json())
  //     .then(res => {
  //       this.setState(
  //         {
  //           latestImages: res.latestImages
  //         },
  //         () => console.log()
  //       );
  //     });
  // }

  render() {
    return (
      <div>
        <Header />
        <Jumbotron />
        <Container fluid />
      </div>
    );
  }
}
