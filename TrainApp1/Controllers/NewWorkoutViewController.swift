//
//  NewWorkoutViewController.swift
//  TrainApp1
//
//  Created by Ivan White on 18.04.2022.
//

import UIKit
import RealmSwift

class NewWorkoutViewController: UIViewController {
    
    private let newWorkoutLabel = UILabel(text: "Новая тренировка", fontName: "Roboto-Medium", fontSize: 28, textColor: .white, opacity: 1)
    
    private let nameLabel = UILabel(text: "Название", fontSize: 12 ,textColor: .specialYellow, opacity: 0.7)
    
    private let nameTextField:UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.textColor = .specialDarkBlue
        field.layer.cornerRadius = 8
        field.borderStyle = .none
        field.font = UIFont(name: "Roboto-Medium", size: 20)
        field.clearButtonMode = .always
        field.returnKeyType = .done /// Кнопка синего цвета на экранной клаве done
        
        /// Что бы был небольшой отступ у правого края при начале ввода
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: field.frame.height))
        field.leftViewMode = .always
        return field
    }()
    
    private let dateLabel = UILabel(text: "Дата и напоминание", fontSize: 12, textColor: .specialYellow, opacity: 0.7)
    
    private let dateAndRepeatView = DateAndRepeatView()
    
    private let timerLabel = UILabel(text: "Повторения или время", fontSize: 12, textColor: .specialYellow, opacity: 0.7)
    
    private let repsOrTimer = RepsOrTimerView()
    
    private let localRealm = try! Realm()
    
    private var workoutModel = WorkoutModel()
    
    private let saveButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .specialDarkBlue
        button.backgroundColor = .specialYellow
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(saveFuncButton), for: .touchUpInside)
        return button
    }()
    
    private let backButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .specialDarkBlue
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.left.fill"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(backFuncButton), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setContrains()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialDarkBlue
        view.addSubview(newWorkoutLabel)
        view.addSubview(nameLabel)
        view.addSubview(dateLabel)
        view.addSubview(nameTextField)
        view.addSubview(dateAndRepeatView)
        view.addSubview(timerLabel)
        view.addSubview(repsOrTimer)
        view.addSubview(saveButton)
        view.addSubview(backButton)
    }
    
    @objc private func backFuncButton() {
        dismiss(animated: true)
    }
    
    @objc private func saveFuncButton() {
        setModel()
        RealmManager.shared.saveWorkoutModel(model: workoutModel)
        workoutModel = WorkoutModel()
    }
    
    private func setModel() {
        guard let nameWorkout = nameTextField.text else { return }
        workoutModel.workoutName = nameWorkout
        
        let dateFromPicker = dateAndRepeatView.setDateAndRepeat().0
        workoutModel.workoutDate = dateFromPicker
        workoutModel.workoutNumberOfDay = dateFromPicker.getWeekdayNumber()
        
        workoutModel.workoutRepeat = dateAndRepeatView.setDateAndRepeat().1
        workoutModel.workoutSets = repsOrTimer.setDateAndRepeat().0
        workoutModel.workoutReps = repsOrTimer.setDateAndRepeat().1
        workoutModel.workoutTimer = repsOrTimer.setDateAndRepeat().2
    }
    
}

// MARK: - setContrains
extension NewWorkoutViewController {
    private func setContrains() {
        NSLayoutConstraint.activate([
            newWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            newWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: newWorkoutLabel.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            dateAndRepeatView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            dateAndRepeatView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dateAndRepeatView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            dateAndRepeatView.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: dateAndRepeatView.bottomAnchor, constant: 40),
            timerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            repsOrTimer.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 5),
            repsOrTimer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            repsOrTimer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            repsOrTimer.heightAnchor.constraint(equalToConstant: 293)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: repsOrTimer.bottomAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            saveButton.widthAnchor.constraint(equalToConstant: 120),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: repsOrTimer.bottomAnchor, constant: 40),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60),
            backButton.widthAnchor.constraint(equalToConstant: 120),
            backButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}