import React, { Component } from "react";
import { Typeahead } from "react-bootstrap-typeahead";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Container,
  Image,
  Carousel,
  Jumbotron,
  Spinner,
} from "react-bootstrap";
import ImageUploader from "react-images-upload";

class ReportMaintenance extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      machine: null,
      issue: "",
      machines: [],
      pictures: [],
      loading: false,
    };

    this.getMachines = this.getMachines.bind(this);

    this.getMachines();
    this.onDrop = this.onDrop.bind(this);
  }

  onDrop(picture) {
    this.setState({
      pictures: this.state.pictures.concat(picture),
    });
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    let machine = String(this.state.machine).split(" -")[0];
    const formData = new FormData();
    formData.append("file", this.state.pictures[0]);
    formData.append("machine", machine);
    formData.append("issue", this.state.issue);
    this.setState({
      loading: true,
    }),
      () => console.log();
    fetch("http://192.168.1.153:4000/machines/submitReport", {
      method: "POST",

      body: formData,
    }).then(() => this.handleRouteChange());
  };

  handleRouteChange() {
    window.location.reload(false);
  }

  validateForm() {
    if (this.state.issue === "") {
      return false;
    }
    if (this.state.machines.indexOf(String(this.state.machine)) === -1) {
      return false;
    }

    return true;
  }

  getMachines() {
    fetch(`http://192.168.1.153:4000/machines/getAll/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        const machines = [];
        for (const machine of res) {
          if (machine.client) {
            const name = machine.machineNo + " - " + machine.client.name;
            machines.push(name);
          }
        }
        this.setState({
          machines: machines,
        }),
          () => console.log();
      });
  }

  render() {
    if (this.state.loading) {
      return (
        <Container>
          <br></br>
          <Jumbotron>
            <Spinner animation="border" role="status"></Spinner>
          </Jumbotron>
        </Container>
      );
    }
    return (
      <div>
        <Container>
          <br></br>
          <Jumbotron>
            <h1 id="justice">
              <b>Submit Report</b>
            </h1>
            <br />

            <form onSubmit={this.handleSubmit}>
              <FormGroup className="userId" controlId="machine">
                <FormLabel>Machine</FormLabel>
                <Typeahead
                  id="basic-typeahead-multiple"
                  labelKey="name"
                  clearButton
                  onChange={(option, e) => {
                    this.setState({
                      machine: option,
                    });
                  }}
                  options={this.state.machines}
                  placeholder="Choose a machine..."
                  selected={this.state.machine}
                />
              </FormGroup>
              <FormGroup className="clientId" controlId="issue">
                <FormLabel>Issue</FormLabel>
                <FormControl
                  size="lg"
                  value={this.state.issue}
                  onChange={this.handleChange}
                ></FormControl>
              </FormGroup>
              <FormLabel>Image</FormLabel>
              <ImageUploader
                withIcon={true}
                buttonText="Choose images"
                onChange={this.onDrop}
                withPreview
                withLabel={false}
                imgExtension={[".jpg", ".gif", ".png", ".gif"]}
                maxFileSize={5242880}
              />
              <Button
                disabled={!this.validateForm()}
                type="submit"
                onClick={this.onSubmit}
              >
                Submit
              </Button>{" "}
              <Button variant="danger" onClick={this.delete}>
                Clear
              </Button>
            </form>
          </Jumbotron>
        </Container>
      </div>
    );
  }
}
export default withRouter(ReportMaintenance);
