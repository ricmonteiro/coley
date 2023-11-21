import React from 'react'
import { useNavigate, useLocation } from 'react-router-dom';
import { useState, useEffect } from 'react';
import { Form, Button, Alert } from 'react-bootstrap'
import axios from 'axios'


function CreateSample() {
  const navigate = useNavigate();
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged;
  const authUser = location.state && location.state.authUser;

  const [loading, setLoading] = useState('')
  const [error, setError] = useState('')
  const [patientList, setPatientList] = useState([])
  const [tissueTypes, setTissueTypes] = useState([])
  const [tumorTypes, setTumorTypes] = useState([])
  const [temperatures, setTemperatures] = useState([])
  const [containers, setContainers] = useState([])

  const [selectedPatient, setSelectedPatient] = useState('')
  const [selectedTissue, setSelectedTissue] = useState('')
  const [selectedTumor, setSelectedTumor] = useState('')
  const [selectedTemperature, setSelectedTemperature] = useState('')
  const [origin, setOrigin] = useState('')
  const [selectedUser, setSelectedUser] = useState('')
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [selectedContainer, setSelectedContainer] = useState('')

  const [successMessage, setSuccessMessage] = useState('')
  const [submitError, setSubmitError] = useState('')

  useEffect(() => { 
    if(isLogged){

    const fieldData = async () => { 
      let sampleCreateEndpoints = [
        "/patient_list/",
        "/tissuetypes/",
        "/tumortypes/",
        "/temperatures/",
        "/containers/",
      ]
      
      try {
      setLoading(true)
      axios.all(sampleCreateEndpoints.map((endpoint) => axios.get(endpoint))).then(
        axios.spread(({data: patients}, {data:tissues}, {data:tumors}, {data:temperatures}, {data:containers}) => {
          setPatientList(patients.data)
          setTissueTypes(tissues.data)
          setTumorTypes(tumors.data)
          setTemperatures(temperatures.data)
          setContainers(containers.data)    
  
        })
        
      );setLoading(false)}catch
      {
        setError("The data necessary to create a sample is not available")
      }
      
    }

    fieldData()
    setLoading(false)
    setSelectedUser(authUser["0"]["id"])
  }else{navigate('/')}},[navigate, authUser, isLogged])
  
  const handleSubmit = (event) => {

      event.preventDefault();

      var formData = {
        user: selectedUser,
        origin: origin,
        selectedPatient: selectedPatient,
        selectedTumor: selectedTumor,
        selectedTissue: selectedTissue,
        selectedDate: selectedDate,
        selectedTemperature: selectedTemperature,
        selectedContainer: selectedContainer,
        };

        axios.post('/new_sample/', formData, {
          headers: {
            'Content-Type': 'application/json',
          },
        })
          .then(response => {
            setSuccessMessage(response.data.message)
          })
          .catch(error => {
            error.message = 'There was an error registering sample. '
            setSubmitError(error.message)
          });
    }

    const handleCancel = (event) => {
      console.log(isLogged)

      navigate('/dashboard', { state : { isLogged, selectedRole, authUser }})
    }

    const handleChangePatient = (event) => {
      setSelectedPatient(event.target.value)
    }
    
    const handleChangeOrigin = (event) => {
      setOrigin(event.target.value)    
    }
    
    const handleChangeTissue = (event) => {
      setSelectedTissue(event.target.value)
    } 

    const handleChangeTumor = (event) => {
      setSelectedTumor(event.target.value)
    }     
    
    const handleChangeDate = (event) => {
      setSelectedDate(event.target.value)    
    }

    const handleChangeTemperature = (event) => {
      setSelectedTemperature(event.target.value)
    } 

    const handleChangeContainer = (event) => {
      setSelectedContainer(event.target.value)
    } 

      return (
        <div>
          <Form onSubmit={handleSubmit}>
           
          <h1>Register a new sample</h1>
          <Form.Label>Select patient
          <Form.Select
        value={selectedPatient}
        onChange={handleChangePatient}>
        <option value="" disabled>Select patient</option>
        {patientList.map((patient) => {
        return (
          <option key={patient["0"]["id"]} value={patient["0"]["id"]}>{patient["0"]["id"]} : {patient["0"]["patient_name"]}</option>
        );
      })}

      </Form.Select>
      </Form.Label>

        <Form.Label>Origin</Form.Label>
      <Form.Control
        type="text"
        onChange={handleChangeOrigin}
      />

      <Form.Label>Select tumor
          <Form.Select
          value={selectedTumor}
          onChange={handleChangeTumor}>
            <option value="" disabled>Select tumor</option>
            {tumorTypes.map((tumor) => {
              return (
                <option key={tumor["0"]["id"]} value={tumor["0"]["id"]}>{tumor["0"]["tumor_description"]}</option>
              );
            })}
                     

          </Form.Select>
          </Form.Label>

        <Form.Label>Select tissue type
          <Form.Select
          value={selectedTissue}
          onChange={handleChangeTissue}>
            <option value="" disabled>Select tissue</option>
            {tissueTypes.map((tissue) => {
              return (
                <option key={tissue["0"]["id"]} value={tissue["0"]["id"]}>{tissue["0"]["tissue_description"]}</option>
              );
            })}

        </Form.Select>
        </Form.Label>    

        <Form.Label>Select date</Form.Label>
        <Form.Control type="date" value={selectedDate} name="entry-date" placeholder="Date of Birth" onChange={handleChangeDate} />  

        <Form.Label>Select temperature
          <Form.Select
          value={selectedTemperature}
          onChange={handleChangeTemperature}>
            <option value="" disabled>Select temperature</option>
            {temperatures.map((temperature) => {
              return (
                <option key={temperature["0"]["id"]} value={temperature["0"]["id"]}>{temperature["0"]["temperature_desc"]}</option>
              );
            })} 
        </Form.Select>
        </Form.Label>

        <Form.Label>Select container where sample will be stored:
          <Form.Select
          value={selectedContainer}
          onChange={handleChangeContainer}>
            <option value="" disabled>Select container</option>
            {containers.map((container) => {
              return (
                <option key={container["0"]["id"]} value={container["0"]["id"]}>{container["0"]["container_name"]}</option>
              );
            })} 
        </Form.Select>
        </Form.Label>

          {error && <p>{error}</p>}
          {(successMessage && <Alert variant='success'>{successMessage}</Alert>) || (submitError && <Alert variant='danger'>{submitError}</Alert>)}
          <Button className='button m-2' type='Submit'>Register sample</Button>
          <Button  className='button m-2' style={{ backgroundColor: "black" }} onClick={handleCancel}>Back</Button>
          
          </Form>
          </div>  
      );
}

export default CreateSample