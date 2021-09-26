import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Image,
  Carousel,
} from "react-bootstrap";

class NewMachine extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      machineNo: "",
      machineType: "",
      clientName: "",
      serialNo: "",
      model: "",
      types: [],
      attributes: [],
      clients: [],
    };
    this.getTypes = this.getTypes.bind(this);
    //this.getAttributes = this.getAttributes.bind(this);
    this.getClients = this.getClients.bind(this);
    this.getClients();
    this.getTypes();
    //this.getAttributes();
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    fetch("http://192.168.1.153:4000/machines/newMachine", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        this.props.getMachines();
      });
  };

  handleRouteChange() {
    window.location.reload(false);
  }

  validateForm() {
    if (this.state.machineNo === "") {
      return false;
    }
    if (this.state.machineType === "") {
      return false;
    }
    return true;
  }

  getTypes() {
    fetch(`http://192.168.1.153:4000/machines/getTypes/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        let types = [];

        res.forEach((element) => {
          types.push(<option>{element.type}</option>);
        });

        this.setState({
          types: types,
          machineType: types[0].props.children,
        }),
          () => console.log();
      });
  }

  getClients() {
    fetch(`http://192.168.1.153:4000/clients/getAll/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        let types = [];
        types.push(<option>{""}</option>);
        res.forEach((element) => {
          types.push(<option>{element.name}</option>);
        });

        this.setState({
          clients: types,
          clientName: types[0].props.children,
        }),
          () => console.log();
      });
  }

  // getAttributes() {
  //   fetch(`http://192.168.1.153:4000/machines/getMachineAttributes/`, {
  //     method: "GET",
  //     credentials: "same-origin",
  //     headers: {
  //       "Content-Type": "application/json",
  //     },
  //   })
  //     .then((response) => response.json())
  //     .then((res) => {
  //       let attributes = [];
  //       res.forEach((element) => {
  //         attributes.push(
  //           <FormGroup controlId={element}>
  //             <FormLabel>{element}</FormLabel>
  //             <FormControl
  //               onChange={this.handleChange}
  //               as="textarea"
  //               rows={1}
  //             />
  //           </FormGroup>
  //         );
  //       });

  //       this.setState({
  //         attributes: attributes,
  //       }),
  //         () => console.log();
  //     });
  // }

  render() {
    return (
      <div>
        <br></br>
        <h1 id="justice">
          <b>Add New Machine</b>
        </h1>
        <br />
        <form onSubmit={this.handleSubmit}>
          <FormGroup className="userId" controlId="machineNo">
            <FormLabel>Machine Number</FormLabel>
            <FormControl
              size="lg"
              value={this.state.machineNo}
              onChange={this.handleChange}
            ></FormControl>
          </FormGroup>
          <FormGroup className="userId" controlId="machineType">
            <FormLabel>Machine Type</FormLabel>
            <FormControl
              as="select"
              size="lg"
              value={this.state.machineType}
              onChange={this.handleChange}
            >
              {this.state.types}
            </FormControl>
          </FormGroup>
          <FormGroup className="clientId" controlId="clientName">
            <FormLabel>Client</FormLabel>
            <FormControl
              as="select"
              size="lg"
              value={this.state.clientName}
              onChange={this.handleChange}
            >
              {this.state.clients}
            </FormControl>
          </FormGroup>
          <FormGroup className="clientId" controlId="model">
            <FormLabel>Model</FormLabel>
            <FormControl
              size="lg"
              value={this.state.model}
              onChange={this.handleChange}
            ></FormControl>
          </FormGroup>
          <FormGroup className="clientId" controlId="serialNo">
            <FormLabel>Serial No.</FormLabel>
            <FormControl
              size="lg"
              value={this.state.serialNo}
              onChange={this.handleChange}
            ></FormControl>
          </FormGroup>

          {this.state.attributes}

          <Button
            block
            disabled={!this.validateForm()}
            type="submit"
            onClick={this.onSubmit}
          >
            Agregar
          </Button>
        </form>
      </div>
    );
  }
}
export default withRouter(NewMachine);
