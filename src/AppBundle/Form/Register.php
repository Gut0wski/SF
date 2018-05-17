<?php

namespace AppBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\PasswordType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\RepeatedType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\OptionsResolver\OptionsResolver;
use AppBundle\Entity\Users;

/**
 * Класс формы регистрации
 * @package AppBundle\Form
 */
class Register extends AbstractType
{
    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('username', TextType::class, [
                'label' => 'Логин',
                'attr' => ['class' => 'form-control']
            ])
            ->add('email', EmailType::class, [
                'label' => 'Email',
                'attr' => ['class' => 'form-control']
            ])
            ->add('telephone', TextType::class, [
                'label' => 'Телефон',
                'attr' => ['class' => 'form-control']
            ])
            ->add('fio', TextType::class, [
                'label' => 'Ф.И.О.',
                'attr' => ['class' => 'form-control']
            ])
            ->add('sector', TextType::class, [
                'label' => 'Номер участка',
                'attr' => ['class' => 'form-control']
            ])
            ->add('password', RepeatedType::class, [
                'type' => PasswordType::class,
                'label' => 'Пароль',
                'invalid_message' => 'Поля паролей должны совпадать',
                'first_options' => [
                    'label' => false,
                    'attr' => [
                        'class' => 'form-control',
                        'style' => 'margin-bottom:1px'
                    ]
                ],
                'second_options' => [
                    'label' => false,
                    'attr' => ['class' => 'form-control']
                ]
            ])
            ->add('submit', SubmitType::class, [
                'attr' => [
                    'class' => 'btn btn-success'
                ],
                'label' => 'Зарегистрироваться'
            ]);
    }

    /**
     * @param OptionsResolver $resolver
     */
    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => Users::class
        ]);
    }
}