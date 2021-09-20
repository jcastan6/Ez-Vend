import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  Row,
  Col,
  Container,
  Jumbotron,
  Form,
  Card,
} from "react-bootstrap";

import DataTable, { createTheme } from "react-data-table-component";
import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";
import WeekdayPicker from "reactjs-weekday-picker";
import "react-day-picker/lib/style.css";
const arrayMove = require("array-move");
import {
  BsFillPlusSquareFill,
  BsFillCaretUpFill,
  BsFillCaretDownFill,
  BsFillXCircleFill,
} from "react-icons/bs";
class NewRoute extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    if (this.props.route) {
      this.state = {
        machines: [],
        id: this.props.route.id,
        route: [],
        employees: [],
        types: [],
        clients: [],
        routeName: this.props.route.name,
        routeEmployees: this.props.route.employees,
        routeMachines: this.props.route.vendingMachines,
      };
    } else {
      this.state = {
        machines: [],
        route: [],
        employees: [],
        types: [],
        clients: [],
        routeName: "",
        routeEmployees: [],
        routeMachines: [],
      };
    }
    this.getTypes = this.getTypes.bind(this);
    this.renderMachines = this.renderMachines.bind(this);
    this.getMachines = this.getMachines.bind(this);
    this.getClients = this.getClients.bind(this);
    this.getEmployees = this.getEmployees.bind(this);
    this.addEmployee = this.addEmployee.bind(this);
    this.removeEmployee = this.removeEmployee.bind(this);
    this.renderMachines = this.renderMachines.bind(this);
    this.removeMachine = this.removeMachine.bind(this);
    this.reorderMachines = this.reorderMachines.bind(this);
    this.saveRoute = this.saveRoute.bind(this);
    this.getEmployees();
    this.getClients();
    this.getTypes();
    this.getMachines();
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  saveRoute() {
    if (!this.props.route) {
      fetch("http://localhost:4000/routes/addRoute", {
        method: "POST",
        credentials: "same-origin",
        body: JSON.stringify(this.state),
        headers: {
          "Content-Type": "application/json",
        },
      })
        .then((res) => res.json())
        .then((res) => {
          this.props.getRoutes();
        });
    } else {
      fetch("http://localhost:4000/routes/editRoute", {
        method: "POST",
        credentials: "same-origin",
        body: JSON.stringify(this.state),
        headers: {
          "Content-Type": "application/json",
        },
      })
        .then((res) => res.json())
        .then((res) => {
          this.props.getRoutes();
        });
    }
  }

  handleRouteChange() {
    window.location.reload(false);
  }

  getMachines() {
    fetch(`http://localhost:4000/machines/getAll/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        res.forEach((machine) => {
          machine.add = (
            <a onClick={() => this.addToRoute(machine)}>
              <BsFillPlusSquareFill></BsFillPlusSquareFill>
            </a>
          );

          if (!machine.type) {
            machine.type = "";
          } else {
            machine.type = machine.type.type;
          }

          if (!machine.client) {
            machine.client = "";
          } else {
            machine.client = machine.client.name;
          }
        });
        this.setState(
          {
            machines: res,
          },
          () => console.log()
        );
      });
  }

  getEmployees() {
    this.setState({
      employees: [],
    });
    fetch(`http://localhost:4000/users/getEmployees`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        res.forEach((employee) => {
          employee.add = (
            <a onClick={() => this.addEmployee(employee)}>
              <BsFillPlusSquareFill></BsFillPlusSquareFill>
            </a>
          );
        });
        res.sort((a, b) => (a.name > b.name ? 1 : -1));
        this.setState(
          {
            employees: res,
          },
          () => console.log()
        );
      });
  }

  getTypes() {
    fetch(`http://localhost:4000/machines/getTypes/`, {
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
    fetch(`http://localhost:4000/clients/getAll/`, {
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

  addToRoute(machine) {
    let machines = this.state.routeMachines;
    machines.push(machine);
    this.setState({
      routeMachines: machines,
    }),
      () => console.log();
  }

  addEmployee(employee) {
    if (!this.state.routeEmployees.includes(employee)) {
      let employees = this.state.routeEmployees;
      employees.push(employee);
      this.setState({
        routeEmployees: employees,
      }),
        () => console.log();
    }
  }
  removeEmployee(employee) {
    let employees = this.state.routeEmployees;
    employees.splice(employees.indexOf(employee), 1);
    this.setState({
      routeEmployees: employees,
    }),
      () => console.log();
  }

  reorderMachines(order, i) {
    let machines = this.state.routeMachines;
    if (order === "up") {
      if (i !== 0) {
        machines = arrayMove(machines, i, i - 1);
      }
    }
    if (order === "down") {
      if (i !== this.state.routeMachines.length) {
        machines = arrayMove(machines, i, i + 1);
      }
    }
    this.setState({
      routeMachines: machines,
    }),
      () => console.log();
  }
  employeeCards() {
    if (this.state.routeEmployees.length > 0) {
      let cards = [];

      this.state.routeEmployees.forEach((employee) => {
        cards.push(
          <div>
            <br />
            <a onClick={this.removeEmployee}>
              <Card body>{employee.name}</Card>
            </a>
          </div>
        );
      });
      return cards;
    }
  }

  removeMachine(machine) {
    let machines = this.state.routeMachines;

    machines.splice(machines.indexOf(machine), 1);
    this.setState({
      routeMachines: machines,
    }),
      () => console.log();
  }

  machineCards() {
    if (this.state.routeMachines.length > 0) {
      let cards = [];

      for (let index = 0; index < this.state.routeMachines.length; index++) {
        cards.push(
          <div>
            <br />
            <Card body>
              {this.state.routeMachines[index].machineNo}
              <Row className="justify-content-end">
                <Col md="2">
                  <a onClick={() => this.reorderMachines("up", index)}>
                    <BsFillCaretUpFill />
                  </a>
                </Col>
                <Col md="2">
                  <a onClick={() => this.reorderMachines("down", index)}>
                    <BsFillCaretDownFill />
                  </a>
                </Col>
                <Col md="2">
                  <a onClick={() => this.removeMachine(index)}>
                    <BsFillXCircleFill />
                  </a>
                </Col>
              </Row>
            </Card>
          </div>
        );
      }

      return cards;
    }
  }

  renderMachines() {
    createTheme("machines", {
      text: {
        primary: "#00000",
        secondary: "#000000",
      },

      background: {
        default: "rgba(0,0,0,0)",
      },
      context: {
        background: "rgba(0,0,0,.2)",
        text: "#000000",
      },
      divider: {
        default: "rgba(0,0,0,.2)",
      },
      action: {
        button: "rgba(0,0,0,1)",
        hover: "rgba(0,0,0,.08)",
        disabled: "rgba(0,0,0,.12)",
      },
    });
    const columns = [
      {
        name: "MachineNo",
        selector: "machineNo",
        sortable: true,
      },
      {
        name: "Type",
        selector: "type",
        sortable: true,
      },
      {
        name: "Client",
        selector: "client",
        sortable: true,
        right: true,
      },
      {
        name: "Add",
        selector: "add",
        sortable: false,
        right: true,
      },
    ];

    const employeeColumns = [
      {
        name: "Name",
        selector: "name",
        sortable: true,
      },
      {
        name: "Type",
        selector: "type",
        sortable: true,
      },
      {
        name: "Add",
        selector: "add",
        sortable: false,
        right: true,
      },
    ];

    if (this.state.machines.length > 0) {
      var modifiers = {
        weekend: function (weekday) {
          return weekday == 0 || weekday == 6;
        },
      };
      const data = this.state.machines;
      return (
        <Container>
          <Row>
            <Col>
              <Jumbotron>
                <Button onClick={() => this.saveRoute()}>Save</Button>{" "}
                <Button variant="danger" onClick={() => this.deleteRoute()}>
                  Delete
                </Button>
                <br />
                <br />
                <Card body>
                  <Form.Group controlId="routeName">
                    <Form.Label>Name</Form.Label>
                    <Form.Control
                      autoFocus
                      type="type"
                      value={this.state.routeName}
                      onChange={this.handleChange}
                    />
                  </Form.Group>
                </Card>
                <br></br>
                <Card body>
                  <Card.Title>Employees</Card.Title>
                  {this.employeeCards()}
                </Card>
                <br></br>
                <Card body>
                  <Card.Title>Machines</Card.Title>
                  {this.machineCards()}
                </Card>
              </Jumbotron>
            </Col>
            <Col>
              <Jumbotron>
                <Card body>
                  <Card.Title>Machines</Card.Title>
                  <DataTableExtensions
                    filterHidden={false}
                    columns={columns}
                    data={this.state.machines}
                  >
                    <DataTable
                      data={this.state.machines}
                      noHeader
                      theme="machines"
                      columns={columns}
                      pagination
                      highlightOnHover
                    />
                  </DataTableExtensions>
                </Card>
                <br />
                <Card body>
                  <Card.Title>Employees</Card.Title>
                  <DataTableExtensions
                    filterHidden={false}
                    columns={employeeColumns}
                    data={this.state.employees}
                  >
                    <DataTable
                      data={this.state.employees}
                      noHeader
                      theme="machines"
                      columns={columns}
                      pagination
                      highlightOnHover
                    />
                  </DataTableExtensions>
                </Card>
              </Jumbotron>
            </Col>
          </Row>
        </Container>
      );
    }
  }

  render() {
    return <div>{this.renderMachines()}</div>;
  }
}
export default withRouter(NewRoute);
