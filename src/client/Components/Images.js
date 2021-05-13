import React, { Component } from "react";
import "../App.css";
import { Image, Row, Col } from "react-bootstrap";
import HashMap from "hashmap";

export default class Images extends Component {
  // photos are static in order to use them across different Instagram instances. That way, the page can keep track of which images are being displayed across the site, without repetition.
  static photos = [];

  static photosMap = new HashMap();

  static next = "";

  constructor() {
    super();
    this.state = {
      photos: [],
      photosArray: [],
      next: ""
    };
    this.assign = this.assign.bind(this);
  }

  assign = async () => {
    if (Instagram.photos.length === 0) {
      Instagram.photos = this.state.photos;
      Instagram.next = this.state.next;
    }

    for (let i = 0; i < this.props.limit; i++) {
      const photo =
        Instagram.photos[Math.floor(Math.random() * Instagram.photos.length)];
      if (
        // only use unique photos, filter out duplicates
        photo.media_type === "IMAGE" &&
        Instagram.photosMap.get(photo) !== 1
      ) {
        this.state.photosArray.push(
          <Image className="insta-image" src={photo.media_url} rounded fluid />
        );
        Instagram.photosMap.set(photo, 1);
      } else {
        i--;
      }
    }
    this.setState({}, () => console.log());
  };

  componentDidMount = async () => {
    fetch(
      `https://graph.instagram.com/me/media?fields=caption,media_url,media_type&access_token=${accessToken}`,
      {
        method: "GET",
        credentials: "same-origin",
        headers: {
          "Content-Type": "application/json"
        }
      }
    )
      .then(response => response.json())
      .then(res => {
        this.setState(
          {
            photos: res.data,
            next: res.paging.next
          },
          () => this.assign()
        );
      });
  };

  render() {
    return (
      <div className="photo-container">
        <div className="title">{this.props.title ? "Instagram" : ""}</div>
        <Row className="justify-content-md-center">
          {this.state.photosArray}
        </Row>
      </div>
    );
  }
}
