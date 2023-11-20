import React from 'react'
import { Form, Button, Alert } from 'react-bootstrap'
import { useNavigate, useLocation } from 'react-router-dom';
import { useEffect, useState } from 'react';
import axios from 'axios'


function CreateCut() {
  const navigate = useNavigate();
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged
  const authUser = location.state && location.state.authUser
  const [samples, setSamples] = useState([])
  const [availableCuts, setAvailableCuts] = useState([])
  const [error, setError] = useState('')
  const [selectedSample, setSelectedSample] = useState('')
  const [selectedDate, setSelectedDate] = useState('')
  const [selectedCut, setSelectedCut] = useState('')
  const [purpose, setPurpose] = useState('')
  const [successMessage, setSuccessMessage] = useState('')
  const [submitError, setSubmitError] = useState('')


  useEffect(() => {
    console.log()
    if (isLogged) {
      axios.get('/samples').then(resp => {
        setSamples(resp.data.data)
      });
    } else { navigate('/') }
  }, [navigate])

  const handleChangeSample = (event) => {

    setSelectedSample(event.target.value)

  }

  const handleCutsAvailable = (event) => {

  }

  const handleChangeCut = (event) => {

  }

  const handleCancel = (event) => {

    navigate('/dashboard', { state: { isLogged, selectedRole, authUser } })

  }

  const handleChangePurpose = (event) => {

    setPurpose(event.target.value)

  }

  const handleChangeDate = (event) => {

    setSelectedDate(event.target.value)  

  }

  const handleSubmit = (event) => {
    event.preventDefault();
    console.log(authUser)
    var formData = {
      
      user: authUser[0]['id'],
      sample: selectedSample,
      purpose: purpose,   
      date: selectedDate,

    };

    console.log(formData)

    axios.post('/new_cut/', formData, {
      headers: {
        'Content-Type': 'application/json',
      },
    })
      .then(response => {
        setSuccessMessage(response.data.message)
      })
      .catch(error => {
        error.message = 'There was an error creating the cut. '
        setSubmitError(error.message)
      });
  }


  return (
    <Form onSubmit={handleSubmit}>

      <h1>Create a cut from a sample</h1>

      <Form.Label>Select sample
        <Form.Select
          value={selectedSample}
          onChange={handleChangeSample}>
          <option value="" disabled>Select sample</option>
          {samples.map((sample) => {
            return (
              <option key={sample["0"]["id"]} value={sample["0"]["id"]}>sample id: {sample["0"]["id"]}, origin: {sample["0"]["origin"]}, from {sample["0"]["entry_date"]}</option>
            );
          })}

        </Form.Select>
      </Form.Label>

      <Form.Label>Purpose</Form.Label>
      <Form.Control

        type="text"
        onChange={handleChangePurpose}

      />

      <Form.Label>Select date</Form.Label>
      <Form.Control type="date" value={selectedDate} name="entry-date" placeholder="Cut creations date" onChange={handleChangeDate} />
      {error && <p>{error}</p>}
      {(successMessage && <Alert variant='success'>{successMessage}</Alert>) || (submitError && <Alert variant='danger'>{submitError}</Alert>)}

      <Button className='button m-2' type='Submit'>Create cut</Button>
      <Button className='button m-2' style={{ backgroundColor: "black" }} onClick={handleCancel}>Back</Button>
    </Form>
  )
}

export default CreateCut;