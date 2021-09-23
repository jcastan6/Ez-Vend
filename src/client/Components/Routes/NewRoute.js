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
import "./NewRoute.css";
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
        id: this.props.route.id,
        route: [],
        employees: [],
        tasks: [],
        routeName: this.props.route.name,
        routeEmployees: this.props.route.employees,
        routeTasks: this.props.route.maintenanceTasks,
      };
    } else {
      this.state = {
        route: [],
        employees: [],
        tasks: [],
        clients: [],
        routeName: "",
        routeEmployees: [],
        routeTasks: [],
      };
    }
    this.getTasks = this.getTasks.bind(this);

    this.getEmployees = this.getEmployees.bind(this);
    this.addEmployee = this.addEmployee.bind(this);
    this.removeEmployee = this.removeEmployee.bind(this);
    this.renderTasks = this.renderTasks.bind(this);
    this.removeTask = this.removeTask.bind(this);
    this.reorderMachines = this.reorderMachines.bind(this);
    this.saveRoute = this.saveRoute.bind(this);
    this.checkTasks = this.checkTasks.bind(this);
    this.checkTasks();
    this.getEmployees();

    this.getTasks();
    //this.getMachines();
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  checkTasks() {
    if (this.props.route) {
      let tasks = this.state.routeTasks;

      tasks.forEach((task) => {
        task.add = (
          <a onClick={() => this.addToRoute(task)}>
            <BsFillPlusSquareFill></BsFillPlusSquareFill>
          </a>
        );
        task.client = task.vendingMachine.client;
      });
      tasks.sort((a, b) =>
        a.employeeTasks.priority > b.employeeTasks.priority ? 1 : -1
      );
      console.log(JSON.stringify(tasks));
      this.setState({
        routeTasks: tasks,
      }),
        () => console.log();
    }
  }

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

  getTasks() {
    fetch(`http://localhost:4000/machines/getAllMaintenanceLogs/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        res.forEach((task) => {
          task.add = (
            <a onClick={() => this.addToRoute(task)}>
              <BsFillPlusSquareFill></BsFillPlusSquareFill>
            </a>
          );
        });
        this.setState({
          tasks: res,
        }),
          () => console.log();
      });
  }

  addToRoute(task) {
    let tasks = this.state.routeTasks;
    if (task.emergency) {
      tasks.unshift(task);
    } else {
      tasks.push(task);
    }
    let allTasks = this.state.tasks;
    allTasks.splice(allTasks.indexOf(task), 1);
    this.setState({
      tasks: allTasks,
      routeTasks: tasks,
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
    let tasks = this.state.routeTasks;
    if (order === "up") {
      if (i !== 0) {
        tasks = arrayMove(tasks, i, i - 1);
      }
    }
    if (order === "down") {
      if (i !== this.state.routeTasks.length) {
        tasks = arrayMove(tasks, i, i + 1);
      }
    }
    this.setState({
      routeTasks: tasks,
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

  removeTask(task) {
    let allTasks = this.state.tasks;

    allTasks.push(this.state.routeTasks[task]);
    let tasks = this.state.routeTasks;
    tasks.splice(task, 1);

    this.setState({
      tasks: allTasks,
      routeTasks: tasks,
    }),
      () => console.log();
  }

  machineCards() {
    if (this.state.routeTasks.length > 0) {
      let cards = [];

      for (let index = 0; index < this.state.routeTasks.length; index++) {
        cards.push(
          <div>
            <br />
            <Card
              body
              className={
                this.state.routeTasks[index].emergency === true
                  ? "emergency-task"
                  : ""
              }
            >
              <Card.Title>
                {this.state.routeTasks[index].vendingMachine.machineNo}
                {" - "}

                {() => {
                  if (this.state.routeTasks[index].client.name) {
                    return this.state.routeTasks[index].client.name + " - ";
                  } else {
                    return "";
                  }
                }}

                {this.state.routeTasks[index].task}
              </Card.Title>
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
                  <a onClick={() => this.removeTask(index)}>
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

  renderTasks() {
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
        selector: "vendingMachine.machineNo",
        sortable: true,
      },
      {
        name: "Task",
        selector: "task",
        sortable: true,
        grow: 3,
      },
      {
        name: "Client",
        selector: "client.name",
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

    const data = this.state.tasks;
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
                <Card.Title>Assigned Tasks</Card.Title>
                {this.machineCards()}
              </Card>
            </Jumbotron>
          </Col>
          <Col>
            <Jumbotron>
              <Card body>
                <Card.Title>Open Tasks</Card.Title>
                <DataTableExtensions
                  filterHidden={false}
                  columns={columns}
                  data={this.state.tasks}
                >
                  <DataTable
                    data={this.state.tasks}
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

  render() {
    return <div>{this.renderTasks()}</div>;
  }
}
export default withRouter(NewRoute);
