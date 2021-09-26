import React, { Component } from "react";
import {
  Form,
  FormGroup,
  FormControl,
  FormLabel,
  Button,
  Container,
} from "react-bootstrap";

import Header from "./Components/Header";
import { retrieveCookie } from "./Components/Cookies";

export default class Upload extends Component {
  constructor(props) {
    super(props);
    this.state = {
      user: retrieveCookie(),
      title: "",
      image: [],
      tags: [],
      tagText: "",
      valid: false,
    };
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.handleKeyPress = this.handleKeyPress.bind(this);
    this.tags = this.tags.bind(this);
    this.removeTag = this.removeTag.bind(this);
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    const formData = new FormData();
    formData.append("image", this.state.image[0]);
    formData.append("userid", this.state.user);
    formData.append("imageDescription", this.state.title);
    formData.append("tags", JSON.stringify(this.state.tags));

    event.preventDefault();
    fetch("http://192.168.1.153:4000/images/new", {
      method: "POST",
      credentials: "same-origin",
      body: formData,
    })
      .then((res) => res.json())
      .then((res) => {
        if (res.status === 401) {
          alert("Unable to Upload");
        } else {
          this.handleRouteChange(res.post.post.postid);
        }
      })
      .catch((err) => {
        console.error(err);
      });
  };

  handleRouteChange(postid) {
    this.props.history.push({
      pathname: `/Post/${JSON.stringify(postid)}`,
    });
  }

  validateForm() {
    return this.state.title.length > 0 && this.state.image;
  }

  addFile = (event) => {
    console.log(event.target.files[0]);
    this.state.image.push(event.target.files[0]);
    this.setState(
      {
        valid: true,
      },
      () => console.log()
    );
  };

  handleKeyPress(target) {
    if (target.charCode == 13) {
      this.state.tags.push(this.state.tagText);
      this.setState(
        {
          tagText: "",
        },
        () => console.log()
      );
      console.log(this.state);
    }
  }

  removeTag(i) {
    const newTags = this.state.tags;
    newTags.splice(i, 1);

    this.setState(
      {
        tags: newTags,
      },
      () => console.log()
    );
  }

  tags() {
    const tags = [];
    for (let i = 0; i < this.state.tags.length; i++) {
      tags.push(
        <Button onClick={() => this.removeTag(i)}>{this.state.tags[i]}</Button>
      );
    }
    return tags;
  }

  render() {
    return (
      <div>
        <Form>
          <FormGroup className="title" controlId="title">
            <FormLabel>Title</FormLabel>
            <FormControl
              autoFocus
              type="username"
              value={this.state.title}
              onChange={this.handleChange}
            />
          </FormGroup>
          <Form.File
            id="custom-file"
            label="Choose an image..."
            custom
            isValid={this.state.valid}
            onChange={this.addFile}
          />

          <FormGroup className="tagText" controlId="tagText">
            <FormLabel>Tags</FormLabel>
            <FormControl
              autoFocus
              type="tag"
              value={this.state.tagText}
              onChange={this.handleChange}
              onKeyPress={this.handleKeyPress}
            />
          </FormGroup>
          <Container>{this.tags()}</Container>
          <Button
            block
            disabled={!this.validateForm()}
            type="button"
            onClick={this.handleSubmit}
          >
            Login
          </Button>
        </Form>
      </div>
    );
  }
}
