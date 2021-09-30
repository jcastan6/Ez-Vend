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
import ReactTooltip from "react-tooltip";
import { Typeahead } from "react-bootstrap-typeahead";

import styled, { keyframes } from "styled-components";
const rotate360 = keyframes`
  from {
    transform: rotate(0deg);
  }

  to {
    transform: rotate(360deg);
  }
`;

const Spinner = styled.div`
  margin: 16px;
  animation: ${rotate360} 1s linear infinite;
  transform: translateZ(0);
  border-top: 2px solid grey;
  border-right: 2px solid grey;
  border-bottom: 2px solid grey;
  border-left: 4px solid black;
  background: transparent;
  width: 80px;
  height: 80px;
  border-radius: 50%;
`;

const CustomLoader = () => (
  <div style={{ padding: "24px" }}>
    <Spinner />
    <div>Cargando...</div>
  </div>
);

import { confirmAlert } from "react-confirm-alert"; // Import
import "react-confirm-alert/src/react-confirm-alert.css"; // Import css
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
        tasksPending: true,
        employeesPending: true,
        routePending: true,
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

    //this.getMachines();
    this.checkTasks();
    this.getEmployees();
    this.getTasks();
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  checkTasks() {
    if (this.state.routeTasks) {
      let tasks = this.state.routeTasks;

      tasks.sort((a, b) =>
        a.employeeTasks.priority > b.employeeTasks.priority ? 1 : -1
      );
      for (const task of tasks) {
        task.client = task.vendingMachine.client;
      }

      this.setState({
        routeTasks: tasks,
      }),
        () => console.log();
    }
  }

  saveRoute() {
    if (!this.props.route) {
      fetch("https://www.mantenimientoscvm.com/routes/addRoute", {
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
      fetch("https://www.mantenimientoscvm.com/routes/editRoute", {
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
      employeesPending: true,
    });
    fetch(`https://www.mantenimientoscvm.com/routes/getEmployees`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        res.sort((a, b) => (a.name > b.name ? 1 : -1));
        this.setState(
          {
            employees: res,
            employeesPending: false,
          },
          () => console.log()
        );
      });
  }

  getTasks() {
    this.setState({
      tasksPending: true,
    });
    fetch(`https://www.mantenimientoscvm.com/machines/getAllMaintenanceLogs/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        this.setState({
          tasks: res,
          tasksPending: false,
        });
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
    });
  }

  addEmployee(employee) {
    let employees = this.state.routeEmployees;
    employees.push(employee);

    let all = this.state.employees;
    all.splice(all.indexOf(employee), 1);
    this.setState({
      employees: all,
      routeEmployees: employees,
    });
  }
  removeEmployee(employee) {
    let employees = this.state.routeEmployees;
    let s = this.state.employees;
    s.push(employee);
    employees.splice(employees.indexOf(employee), 1);

    this.setState({
      employees: s,
      routeEmployees: employees,
    });
  }

  reorderMachines(order, i) {
    let tasks = this.state.routeTasks;
    i = this.state.routeTasks.indexOf(i);
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
            <a onClick={() => this.removeEmployee(employee)}>
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
    let tasks = this.state.routeTasks;
    let index = tasks.indexOf(task);
    allTasks.push(this.state.routeTasks[index]);
    tasks.splice(index, 1);

    this.setState({
      tasks: allTasks,
      routeTasks: tasks,
    });
  }

  machineCards() {
    const customStyles = {
      context: {
        background: "#cb4b16",
        text: "#FFFFFF",
      },
      headCells: {
        style: {
          fontSize: "14px",
        },
      },
      rows: {
        highlightOnHoverStyle: {
          backgroundColor: "rgb(230, 244, 244)",
          borderBottomColor: "#FFFFFF",
          outline: "1px solid #FFFFFF",
        },
      },
      pagination: {
        style: {
          border: "none",
        },
      },
    };

    const columns = [
      {
        name: "Numero de Maquina",
        selector: "vendingMachine.machineNo",
        sortable: true,
      },

      {
        name: "Cliente",
        cell: (row) => {
          if (row.client) {
            return row.client.name;
          } else {
            return "";
          }
        },
        sortable: true,
      },
      {
        name: "Tarea",

        cell: (row) => {
          return (
            <div data-tip={row.task}>
              {row.task} <ReactTooltip />
            </div>
          );
        },
        sortable: false,
      },
      {
        name: "Tipo de Mantenimiento",
        cell: (row) => {
          if (row.emergency) {
            return "Correctivo";
          } else {
            return "Preventivo";
          }
        },

        conditionalCellStyles: [
          {
            when: (row) => row.emergency,
            style: {
              backgroundColor: "rgba(255, 0, 0, 0.3)",
            },
          },
        ],
      },

      {
        name: "Editar",
        cell: (index) => (
          <div>
            <h4>
              <a onClick={() => this.reorderMachines("up", index)}>
                <BsFillCaretUpFill />
              </a>
              {"  "}
              <a onClick={() => this.reorderMachines("down", index)}>
                <BsFillCaretDownFill />
              </a>
              {"  "}
              <a onClick={() => this.removeTask(index)}>
                <BsFillXCircleFill />
              </a>
            </h4>
          </div>
        ),
        sortable: false,
      },
    ];

    return (
      <DataTable
        data={this.state.routeTasks}
        noHeader
        columns={columns}
        pagination
        highlightOnHover
      />
    );
  }

  deleteRoute() {
    confirmAlert({
      title: "Confirmar",
      message: "Seguro que quieres borrar esto?",
      buttons: [
        {
          label: "Yes",
          onClick: () =>
            fetch(`https://www.mantenimientoscvm.com/routes/deleteRoute`, {
              method: "POST",
              body: JSON.stringify(this.state),
              credentials: "same-origin",
              headers: {
                "Content-Type": "application/json",
              },
            })
              .then((response) => response.json())
              .then((res) => {
                this.props.getRoutes();
              }),
        },
        {
          label: "No",
          onClick: () => console.log(),
        },
      ],
    });
  }

  renderTasks() {
    const customStyles = {
      context: {
        background: "#cb4b16",
        text: "#FFFFFF",
      },
      headCells: {
        style: {
          fontSize: "14px",
        },
      },
      rows: {
        highlightOnHoverStyle: {
          backgroundColor: "rgb(230, 244, 244)",
          borderBottomColor: "#FFFFFF",
          outline: "1px solid #FFFFFF",
        },
      },
      pagination: {
        style: {
          border: "none",
        },
      },
    };

    const columns = [
      {
        name: "Numero de Maquina",
        selector: "vendingMachine.machineNo",
        sortable: true,
      },
      {
        name: "Tarea",
        cell: (row) => {
          return <div data-tip={row.task}>{row.task}</div>;
        },
        sortable: false,
        grow: 3,
      },
      {
        name: "Cliente",
        cell: (row) => {
          if (row.client) {
            return row.client.name;
          } else {
            return "";
          }
        },
        sortable: true,
        right: true,
      },
      {
        name: "Tipo de Mantenimiento",
        cell: (row) => {
          if (row.emergency) {
            return "Correctivo";
          } else {
            return "Preventivo";
          }
        },
        right: true,

        conditionalCellStyles: [
          {
            when: (row) => row.emergency,
            style: {
              backgroundColor: "rgba(255, 0, 0, 0.3)",
            },
          },
        ],
      },
      {
        name: "Agregar a Ruta",
        cell: (row) => (
          <a onClick={() => this.addToRoute(row)}>
            <BsFillPlusSquareFill></BsFillPlusSquareFill>
          </a>
        ),
        sortable: false,
        right: true,
      },
    ];

    const employeeColumns = [
      {
        name: "Nombre",
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
        cell: (row) => (
          <a onClick={() => this.addEmployee(row)}>
            <BsFillPlusSquareFill></BsFillPlusSquareFill>
          </a>
        ),
        sortable: false,
        right: true,
      },
    ];

    return (
      <Container fluid>
        <Row>
          <Col lg={6}>
            <Card body className="table">
              <Button onClick={() => this.saveRoute()}>Actualizar</Button>
              {"   "}
              <Button variant="danger" onClick={() => this.deleteRoute()}>
                Borrar
              </Button>
              <br />
              <br />
              <Form.Group controlId="routeName">
                <Form.Label>Empleado</Form.Label>
                <Typeahead
                  defaultSelected={this.state.routeEmployees}
                  id="basic-typeahead-multiple"
                  labelKey="name"
                  clearButton
                  multiple
                  onChange={(option, e) => {
                    this.setState({
                      routeEmployees: option,
                    });
                  }}
                  options={this.state.employees}
                  placeholder="Elejir empleado..."
                  selected={this.state.routeEmployees}
                />
              </Form.Group>
            </Card>
            <br></br>

            <br></br>
            <Card body className="table">
              <Card.Title>Tareas Asignadas</Card.Title>
              {this.machineCards()}
            </Card>
          </Col>
          <Col lg={6}>
            <Card body className="table">
              <Card.Title>Tareas Abiertas</Card.Title>

              <DataTable
                data={this.state.tasks}
                noHeader
                columns={columns}
                progressPending={this.state.tasksPending}
                progressComponent={<CustomLoader />}
                pagination
                customStyles={customStyles}
                highlightOnHover
              />
            </Card>
            <br />
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
