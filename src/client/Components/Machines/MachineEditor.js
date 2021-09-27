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

class MachineEditor extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      id: this.props.machine.id,
      machineNo: this.props.machine.machineNo,
      machineType: this.props.machine.type,
      clientName: this.props.machine.client,
      serialNo: this.props.machine.serialNo,
      model: this.props.machine.model,
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
    fetch("https://www.mantenimientoscvm.com/machines/editMachine", {
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
    fetch(`https://www.mantenimientoscvm.com/machines/getTypes`, {
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
          types.push(<option>{element.type}</option>);
        });
        this.setState(
          {
            types: types,
          },
          () => console.log()
        );
      });
  }

  getClients() {
    fetch(`https://www.mantenimientoscvm.com/clients/getAll/`, {
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
        }),
          () => console.log();
      });
  }

  delete = () => {
    fetch("https://www.mantenimientoscvm.com/machines/deleteMachine", {
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
  render() {
    return (
      <div>
        <br />
        <h1 id="justice">
          <b>Edit Machine</b>
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
            Update
          </Button>
          <Button block variant="danger" onClick={this.delete}>
            Delete
          </Button>
        </form>
      </div>
    );
  }
}
export default withRouter(MachineEditor);
