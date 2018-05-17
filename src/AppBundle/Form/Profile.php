<?php

namespace AppBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\PasswordType;
use Symfony\Component\Form\Extension\Core\Type\RepeatedType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\OptionsResolver\OptionsResolver;
use AppBundle\Entity\Users;

/**
 * Класс формы профиля пользователя
 * @package AppBundle\Form
 */
class Profile extends AbstractType
{
    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('fio', TextType::class, [
                'label' => 'Ф.И.О.',
                'attr' => ['class' => 'form-control']
            ])
            ->add('telephone', TextType::class, [
                'label' => 'Телефон',
                'attr' => ['class' => 'form-control']
            ])
            ->add('email', EmailType::class, [
                'label' => 'Адрес email',
                'attr' => ['class' => 'form-control']
            ])
            ->add('address', TextType::class, [
                'label' => 'Адрес фактического проживания',
                'attr' => ['class' => 'form-control']
            ])
            ->add('sector', TextType::class, [
                'label' => 'Номер участка в СТ',
                'attr' => ['class' => 'form-control']
            ])
            ->add('other_contacts', TextType::class, [
                'label' => 'Другие контактные данные',
                'attr' => ['class' => 'form-control']
            ])
            ->add('password', RepeatedType::class, [
                'type' => PasswordType::class,
                'label' => 'Сменить пароль',
                'invalid_message' => 'Поля паролей должны совпадать',
                'required' => false,
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
                'label' => 'Сохранить информацию'
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